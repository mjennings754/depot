class Product < ApplicationRecord
  has_one_attached :image
  after_commit -> { broadcast_refresh_later_to "products" }
  validates_presence_of :title, :description, :image
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates_uniqueness_of :title

  validate :acceptable_image
  def acceptable_image
    return unless image.attached?
    acceptable_types = ["image/gif", "image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a GIF, JPG or PNG image")
    end
  end
end
