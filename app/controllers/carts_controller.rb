class CartsController < ApplicationController
  
  skip_before_action :admin_user?, except: :destroy
  before_action :load_item, except: [:show, :add_item, :destroy]
  before_action :find_product, only: :add_item

  def show
    
  end

  def add_item
    # If cart already has this product then find the relevant cart_item and iterate quantity otherwise create a new cart_item for this product
    if is_present?(@product)
      # Find the cart_item with the @chosen_product
      @cart_item = current_user.cart.cart_items.find_by(product_id: @product.id)
      flash[:danger] = "Item present in cart, update quantity if needed" 
    else
      details = { cart_id: current_user.cart.id, product_id: @product.id, quantity: 1,
                  total_price: @product.price * (1 + @product.tax_rate / 100) }  
      current_user.cart.cart_items.create(details)
    end 
    redirect_to display_carts_path
  end

  def destroy
    current_user.cart.destroy
    redirect_to profile_users_path
  end

  def update_quantity
    if params[:cart_item][:quantity].to_i <= 0
      flash[:danger] = "Quantity can not be less than 1"  
    elsif @cart_item.product.stock - params[:cart_item][:quantity].to_i <= 0
      flash[:danger] = "Product in stock is less than its quantity in cart"
    else
    	details = cart_item_params
    	details[:total_price] = params[:cart_item][:quantity].to_i * @cart_item.product.price * (1 + @cart_item.product.tax_rate / 100)
      unless @cart_item.update_attributes(details)
        flash[:danger] = @cart_item.errors.full_messages
      end
    end
    redirect_to display_carts_path
  end

  def remove_item
    @cart_item.destroy
    redirect_to display_carts_path
  end

  private

  def load_item
    @cart_item = CartItem.find(params[:item_id]) rescue nil
    if @cart_item.blank?
      flash[:danger] = "This Item Does not exists"
      redirect_to display_carts_path
    elsif @cart_item.cart != current_user.cart
      flash[:danger] = "This Item Does not belongs to your cart"
      redirect_to display_carts_path
    end
  end

  def find_product
    @product = Product.find(params[:product_id]) rescue nil
    if @product.blank?
      flash[:danger] = "Product does not exists"
      redirect_to products_path
    elsif @product.stock == 0
      flash[:danger] = "Product is out of stock! We will notify you whenever it is back in stock"
      redirect_to products_path
    end
  end

  def is_present?(product)
    current_user.cart.cart_items.exists?(product_id: product.id)
  end

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
