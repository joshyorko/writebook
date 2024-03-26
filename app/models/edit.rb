class Edit < ApplicationRecord
  belongs_to :leaf
  delegated_type :leafable, types: Leafable::TYPES, dependent: :destroy

  enum :action, %w[ creation revision trash ].index_by(&:itself)

  scope :sorted, -> { order(created_at: :desc) }

  def current_version?
    leaf.leafable == leafable
  end
end
