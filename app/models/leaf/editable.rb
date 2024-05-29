module Leaf::Editable
  extend ActiveSupport::Concern

  included do
    has_many :edits, dependent: :delete_all

    after_update :record_moved_to_trash, if: :was_trashed?
  end

  def edit(leafable_params: {}, leaf_params: {})
    if will_change_leafable?(leafable_params)
      update_leafable leaf_params, leafable_params
    else
      update! leaf_params
    end
  end

  private
    def will_change_leafable?(leafable_params)
      leafable_params.select do |key, value|
        leafable.attributes[key.to_s] != value
      end.present?
    end

    def update_leafable(leaf_params, leafable_params)
      transaction do
        new_leafable = dup_leafable_with_attachments leafable
        new_leafable.update!(leafable_params)
        edits.revision.create!(leafable: leafable)
        update! leaf_params.merge(leafable: new_leafable)
      end
    end

    def dup_leafable_with_attachments(leafable)
      leafable.dup.tap do |new|
        attachment_reflections.each do |name, _|
          new.send(name).attach(self.send(name).blob)
        end
      end
    end

    def record_moved_to_trash
      edits.trash.create!(leafable: leafable)
    end

    def was_trashed?
      trashed? && previous_changes.include?(:status)
    end
end
