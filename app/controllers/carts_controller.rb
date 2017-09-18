class CartsController < ApplicationController
  
  skip_before_action :admin_user?, except: :destroy
  before_action :load_item, except: [:show, :add_item, :destroy]
  before_action :find_product, only: :add_item

  def show
    @cart = current_user.cart
  end

  def add_item
    # If cart already has this product then find the relevant cart_item and iterate quantity otherwise create a new cart_item for this product
    if is_present?(@chosen_product)
      # Find the cart_item with the @chosen_product
      @cart_item = current_user.cart.cart_items.find_by(product_id: @chosen_product)
      add_quantity
    else
      details = {cart_id: current_user.cart.id, product_id: @chosen_product.id, quantity: 1}  
      @cart_item = CartItem.new(details)
      @cart_item.save 
      redirect_to display_carts_path
    end 
  end

  def destroy
    current_user.cart.destroy
    redirect_to profile_users_path
  end

  def add_quantity
    if @cart_item.product.stock - @cart_item.quantity <= 0
      flash[:danger] = "Product in stock is less than its quantity in cart"
    else
      @cart_item.quantity = 1 if @cart_item.quantity.blank?
      @cart_item.quantity += 1 unless @cart_item.quantity.blank?
      @cart_item.save
    end
    redirect_to display_carts_path
  end

  def reduce_quantity
    if @cart_item.quantity > 1
      @cart_item.quantity -= 1
    else
      @cart_item.destroy
    end
    @cart_item.save
    redirect_to display_carts_path
  end

  def remove_item
    @cart_item.destroy
    redirect_to display_carts_path
  end

  private

  def load_item
    @cart_item = CartItem.find(params[:id]) rescue nil
    if @cart_item.blank?
      flash[:danger] = "This Item Does not belongs to your cart"
      redirect_to display_carts_path
    end
  end

  def find_product
  	@chosen_product = Product.find(params[:product_id]) rescue nil
    if @chosen_product.blank?
      flash[:danger] = "Product does not exists"
      redirect_to products_path
    elsif @chosen_product.stock == 0
      flash[:danger] = "Product is out of stock! We will notify you whenever it is back in stock"
      redirect_to products_path
    end
  end

  def is_present?(product)
  	current_user.cart.products.include?(product)
  end
end
