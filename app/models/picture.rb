class Picture < ApplicationRecord
  include Leafable

  has_one_attached :image do |attachable|
    attachable.variant :large, resize_to_limit: [ 500, 500 ]
  end

  attribute :title, default: "Picture"
end
