class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  validates_uniqueness_of :name
  validates_presence_of :name

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_destroy :ensure_an_admin_remains

  class Error < StandardError
  end

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end
end
