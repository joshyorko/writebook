class User < ApplicationRecord
  include Role

  has_many :sessions, dependent: :destroy
  has_secure_password validations: false

  scope :active, -> { where(active: true) }
end
