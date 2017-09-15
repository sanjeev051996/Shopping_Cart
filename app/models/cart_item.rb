class CartItem < ApplicationRecord
  
  belongs_to :cart
  belongs_to :product
  
  def total_price

    amount = self.quantity * self.product.price * (1 + self.product.tax_rate) if self.product.tax_rate < 1
    amount = self.quantity * self.product.price * (1 + self.product.tax_rate / 100) if self.product.tax_rate > 1
    amount
  end 
end
