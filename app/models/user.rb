class User < ApplicationRecord

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :cart_items, through: :cart
  has_many :order_items, through: :orders
  validates :name, :email, presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
  has_secure_password
end
