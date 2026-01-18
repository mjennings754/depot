class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  validates_uniqueness_of :name
  validates_presence_of :name

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
