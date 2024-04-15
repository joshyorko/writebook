class Section < ApplicationRecord
  include Leafable

  attribute :title, default: "Section"
end
