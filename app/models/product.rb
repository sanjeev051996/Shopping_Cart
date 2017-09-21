class Product < ApplicationRecord

  has_many :cart_items
  has_many :order_items
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
end
