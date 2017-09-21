class Cart < ApplicationRecord

  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items 

  def sub_total
    self.cart_items.inject(0){ |cost, item| cost += item.total_price } 
  end
  
  def total_tax
    self.cart_items.inject(0){ |cost, item| cost += item.quantity * item.product.price * item.product.tax_rate / 100 }
  end
end
