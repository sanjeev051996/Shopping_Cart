class OrdersController < ApplicationController 

  skip_before_action :admin_user?, except: [:index, :destroy, :edit, :update]
  before_action :load_order, except: [:index, :new, :create]

  def index
    @orders = Order.all
  end

  def show
    unless @order.user == current_user || current_user.admin?
      flash[:danger] = "This order does not belongs to you"
    redirect_to profile_path 
    end
  end

  def new
    @order = Order.new
  end

  def edit

  end

  def create
    @order = Order.new(order_params)              
    @order.user = current_user
    @order.save
    @current_user.cart.cart_items.each do |item|
      details = {order_id: @order.id, product_id: item.product_id, price: item.product.price,
                 tax_rate: item.product.tax_rate, quantity: item.quantity}
      order_item = OrderItem.new(details)
      order_item.save
      item.destroy
    end
    @order.amount = @order.sub_total
    @order.tax = @order.total_tax
    @order.save
    redirect_to @order
  end

  def update
    @order.update_attributes(order_params) 
    redirect_to @order
  end

  def destroy
    @order.destroy
    redirect_to orders_path
  end

  def payment
    render 'payment_form' 
  end

  def process_payment
    @order.update_attributes(order_params)
    @order.status = "paid"
    @order.transaction_id = SecureRandom.hex(10)
    @order.payment_date = @order.updated_at.to_date 
    @order.save
    redirect_to @order
  end

  private

  def order_params
    params.require(:order).permit(:status, :transaction_id, :amount, :address, :country,
                                  :state, :zip_code, :card, :cvv, :card_expiry_date, :payment_mode,
                                  :shipped_on, :delivered_on, :payment_date)
  end

  def load_order
    @order = Order.find(params[:id]) rescue nil
    if @order.blank?
      flash[:danger] = "Order Does not exists"
      redirect_to profile_path
    end
  end
end
