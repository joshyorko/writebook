class Page < ApplicationRecord
  include Leafable

  attribute :title, default: "Untitled"
end
