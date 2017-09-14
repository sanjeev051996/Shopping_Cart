class OrdersController < ApplicationController 

  before_action :valid_user, only: [:show]
  before_action :admin_user, only: [:index, :destroy, :edit, :update]

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id]) rescue nil
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id]) rescue nil
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    @order.save
    @current_user.cart.cart_items.each do |item|
      details = {order_id: @order.id, product_id: item.product_id, price: item.price,
                 tax_rate: item.tax_rate, quantity: item.quantity}
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
    @order = Order.find(params[:id]) rescue nil
    @order.update_attributes(order_params) 
    redirect_to @order
  end

  def destroy
    @order = Order.find(params[:id]) rescue nil
    @order.destroy
    redirect_to orders_path
  end

  def payment
    @order = Order.find(params[:id]) rescue nil
    render 'payment_form' 
  end

  def process_payment
    @order = Order.find(params[:id]) rescue nil
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

  def valid_user
    order = Order.find(params[:id]) rescue nil
    unless  order.user == current_user || current_user.admin?
      flash[:danger] = "U are not authorised for this action"
      redirect_to current_user
    end
  end
end
