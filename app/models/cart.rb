class Cart < ApplicationRecord

  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items 

  def sub_total
    sum = 0
    self.cart_items.each do |cart_item|
      sum += cart_item.total_price
    end
    return sum
  end
  def total_tax
    sum = 0
    self.cart_items.each do |cart_item|
      if cart_item.tax_rate < 1 
        sum += cart_item.quantity * cart_item.price * cart_item.tax_rate
      else
        sum += cart_item.quantity * cart_item.price * cart_item.tax_rate / 100
      end
    end
    return sum
  end
end
