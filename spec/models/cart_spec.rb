require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "cart model" do
    context "associations with other models" do
      it "have many cart items" do
        t = Cart.reflect_on_association(:cart_items)
        expect(t.macro).to eq(:has_many)
      end

      it "have many products" do
        t = Cart.reflect_on_association(:products)
        expect(t.macro).to eq(:has_many)
      end

      it "belongs to one user" do
        t = Cart.reflect_on_association(:user)
        expect(t.macro).to eq(:belongs_to)
      end
    end
  end
end
