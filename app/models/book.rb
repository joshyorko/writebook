class Book < ApplicationRecord
  include Accesses, Sluggable

  has_many :leaves, dependent: :destroy
  has_one_attached :cover

  scope :ordered, -> { order(:title) }
  scope :published, -> { where(published: true) }

  def press(leafable, leaf_params)
    transaction do
      leafable.save!
      leaves.create! leaf_params.merge(leafable: leafable)
    end
  end
end
