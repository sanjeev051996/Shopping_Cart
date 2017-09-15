class CartsController < ApplicationController
  
  skip_before_action :admin_user?, except: :destroy
  before_action :load_item, except: [:show, :add_item, :destroy]

  def show
    @cart = current_user.cart
  end

  def add_item
    chosen_product = Product.find(params[:product_id]) rescue nil
    # If cart already has this product then find the relevant cart_item and iterate quantity otherwise create a new cart_item for this product
    if current_user.cart.products.include?(chosen_product)
      # Find the cart_item with the chosen_product
      @cart_item = current_user.cart.cart_items.find_by(product_id: chosen_product)
      # Iterate the cart_item's quantity by one
      @cart_item.quantity = 1 if @cart_item.quantity.blank?
      @cart_item.quantity += 1 unless @cart_item.quantity.blank?
    else
      details = {cart_id: current_user.cart.id, product_id: chosen_product.id, quantity: 1}
      @cart_item = CartItem.new(details)
    end
    # Save and redirect to cart show path
    @cart_item.save
    redirect_to cart_path
  end

  def destroy
  	current_user.cart.destroy
  	redirect_to current_user
  end

  def add_quantity
    @cart_item.quantity = 1 if @cart_item.quantity.blank?
    @cart_item.quantity += 1 unless @cart_item.quantity.blank?
    @cart_item.save
    redirect_to cart_path
  end

  def reduce_quantity
    if @cart_item.quantity > 1
      @cart_item.quantity -= 1
    else
      @cart_item.destroy
    end
    @cart_item.save
    redirect_to cart_path
  end

  def remove_item
    @cart_item.destroy
    redirect_to cart_path
  end

  private


  def load_item
    @cart_item = CartItem.find(params[:id]) rescue nil
    if @cart_item.blank?
      flash[:danger] = "This Item Does not belongs to your cart"
      redirect_to cart_path
    end
  end
end
