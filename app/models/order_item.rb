class OrderItem < ApplicationRecord

  belongs_to :order
  belongs_to :product

  def total_price
    amount = self.quantity * self.price * (1 + self.tax_rate) if self.tax_rate < 1
    amount = self.quantity * self.price * (1 + self.tax_rate / 100) if self.tax_rate > 1
    amount
  end 
end
