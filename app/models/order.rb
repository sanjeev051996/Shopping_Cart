class Order < ApplicationRecord
  
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  belongs_to :user

  def sub_total
    sum = 0
    self.order_items.each do |order_item|
      sum += order_item.total_price
    end
    return sum
  end

  def total_tax
    sum = 0
    self.order_items.each do |order_item|
      if order_item.tax_rate < 1 
        sum += order_item.quantity * order_item.price * order_item.tax_rate
      else
        sum += order_item.quantity * order_item.price * order_item.tax_rate / 100
      end
    end
    return sum
  end
end
