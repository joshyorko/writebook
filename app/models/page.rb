class Page < ApplicationRecord
  include Leafable

  has_markdown :body
end
