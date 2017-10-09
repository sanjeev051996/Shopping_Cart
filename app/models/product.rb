class Product < ApplicationRecord

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
  has_many :cart_items
  has_many :order_items
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
end
