class Book < ApplicationRecord
  include Accessable, Sluggable

  has_many :leaves, dependent: :destroy
  has_one_attached :cover, dependent: :purge_later

  scope :ordered, -> { order(:title) }
  scope :published, -> { where(published: true) }

  def to_param
    "#{slug}-#{id}".parameterize
  end

  def press(leafable, leaf_params)
    leaves.create! leaf_params.merge(leafable: leafable)
  end
end
