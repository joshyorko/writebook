class Leaf < ApplicationRecord
  include Editable, Positionable

  belongs_to :book, touch: true
  positioned_within :book, association: :leaves
  delegated_type :leafable, types: Leafable::TYPES, dependent: :destroy

  enum :status, %w[ active trashed ].index_by(&:itself), default: :draft

  scope :with_leafables, -> { includes(:leafable) }

  def public_param
    "#{id}-#{title}".parameterize
  end
end
