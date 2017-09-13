class CartItemsController < ApplicationController

  def index
  end
   
  def show
  end

  def create
    
    chosen_product = Product.find(params[:product_id]) rescue nil
    # If cart already has this product then find the relevant cart_item and iterate quantity otherwise create a new cart_item for this product
    if current_user.cart.products.include?(chosen_product)
      # Find the cart_item with the chosen_product
      @cart_item = current_user.cart.cart_items.find_by(product_id: chosen_product)
      # Iterate the cart_item's quantity by one
      @cart_item.quantity = 1 if @cart_item.quantity.blank?
      @cart_item.quantity += 1 unless @cart_item.quantity.blank?
    else
      details = {cart_id: current_user.cart.id, product_id: chosen_product.id, price: chosen_product.price,
                 tax_rate: chosen_product.tax_rate, quantity: 1}
      @cart_item = CartItem.new(details)
    end
    # Save and redirect to cart show path
    @cart_item.save
    #binding.pry
    redirect_to current_user.cart
  end

  def destroy
    @cart_item = CartItem.find(params[:id]) rescue nil
    @cart_item.destroy
    redirect_to current_user.cart
  end  

  def add_quantity
    @cart_item = CartItem.find(params[:id]) rescue nil
    @cart_item.quantity = 1 if @cart_item.quantity.blank?
    @cart_item.quantity += 1 unless @cart_item.quantity.blank?
    @cart_item.save
    redirect_to current_user.cart
  end

  def reduce_quantity
    @cart_item = CartItem.find(params[:id]) rescue nil
    if @cart_item.quantity > 1
      @cart_item.quantity -= 1
    else
      @cart_item.destroy
    end
    @cart_item.save
    redirect_to current_user.cart
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :product_id, :cart_id, :price, :tax_rate)
  end
end
