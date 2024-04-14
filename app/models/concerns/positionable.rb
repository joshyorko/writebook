module Positionable
  extend ActiveSupport::Concern

  REBALANCE_THRESHOLD = 1e-10
  ELEMENT_GAP         = 1

  included do
    scope :positioned, -> { order(:position_score, :id) }

    scope :before, ->(other) { positioned.where("position_score < ?", other.position_score) }
    scope :after,  ->(other) { positioned.where("position_score > ?", other.position_score) }

    around_create :insert_at_default_position
    after_save_commit :rebalance_positions, if: :rebalance_required?
  end

  class_methods do
    def positioned_within(parent, association:)
      define_method :positioning_parent do
        send(parent)
      end

      define_method :all_positioned_siblings do
        positioning_parent.send(association).positioned
      end

      define_method :other_positioned_siblings do
        all_positioned_siblings.excluding(self)
      end

      private :positioning_parent, :all_positioned_siblings, :other_positioned_siblings
    end
  end

  def previous
    other_positioned_siblings.before(self).last
  end

  def next
    other_positioned_siblings.after(self).first
  end

  # TODO: the `followed_by` part of this API is a little strange. It's there so
  # we can keep the move operation on the model, while still allowing a
  # collection of items to be moved at once. Feels quite lop-sided though, so
  # worth thinking of a different way to model this.
  def move_to_position(offset, followed_by: [])
    with_positioning_lock do
      all_to_move = [ self, *followed_by ]
      before, after = before_and_after_for(offset: offset, moving: all_to_move)
      gap = (after - before) / (all_to_move.count + 1)

      all_to_move.each.with_index(1) do |item, index|
        item.update!(position_score: before + (index * gap))
      end

      remember_to_rebalance_positions if gap < REBALANCE_THRESHOLD
    end
  end

  private
    def insert_at_default_position
      with_positioning_lock do
        position_at_end
        yield
      end
    end

    def position_at_start
      self.position_score = (all_positioned_siblings.minimum(:position_score) || (2 * ELEMENT_GAP)) - ELEMENT_GAP
    end

    def position_at_end
      self.position_score = (all_positioned_siblings.maximum(:position_score) || 0) + ELEMENT_GAP
    end

    def before_and_after_for(offset:, moving:)
      other_items = all_positioned_siblings.excluding(moving)

      if offset < 1
        after = all_positioned_siblings.minimum(:position_score) || (2 * ELEMENT_GAP)
        before = after - ELEMENT_GAP
      else
        before, after = other_items.offset(offset - 1).limit(2).pluck(:position_score)
        before ||= all_positioned_siblings.maximum(:position_score)
        after ||= before + (moving.count.succ * ELEMENT_GAP)
      end

      [ before, after ]
    end

    def remember_to_rebalance_positions
      @rebalance_required = true
    end

    def rebalance_required?
      @rebalance_required
    end

    def rebalance_positions
      with_positioning_lock do
        odered = all_positioned_siblings.select("row_number() over (order by position_score, id) as new_score, id")
        sql = "update #{self.class.table_name} set position_score = new_score from (#{odered.to_sql}) as ordered where #{self.class.table_name}.id = ordered.id"

        self.class.connection.execute sql
      end
      @rebalance_required = false
    end

    def with_positioning_lock(&block)
      positioning_parent.with_lock &block
    end
end
