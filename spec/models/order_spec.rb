require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "order model" do
    context "associations with other models" do
      it "have many order items" do
        t = Order.reflect_on_association(:order_items)
        expect(t.macro).to eq(:has_many)
      end

      it "have many products" do
        t = Order.reflect_on_association(:products)
        expect(t.macro).to eq(:has_many)
      end

      it "belongs to one user" do
        t = Order.reflect_on_association(:user)
        expect(t.macro).to eq(:belongs_to)
      end
    end
  end
end
