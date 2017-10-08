require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "product model" do
    context "associations with other models" do
      it "have many cart items" do
        t = Product.reflect_on_association(:cart_items)
        expect(t.macro).to eq(:has_many)
      end

      it "have many order items" do
        t = Product.reflect_on_association(:order_items)
        expect(t.macro).to eq(:has_many)
      end
    end

    context "valid attributes" do
      it "has a positive stock" do 
        FactoryGirl.build(:product, stock: 0).should_not be_valid
      end
    end
  end
end
