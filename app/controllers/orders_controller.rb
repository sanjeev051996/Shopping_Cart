class OrdersController < ApplicationController 

  skip_before_action :admin_user?, except: [:index, :destroy, :edit, :update]
  before_action :load_order, except: [:index, :new, :create]
  before_action :authorised_user, only: :show
  before_action :is_valid_checkout?, only: :new
  def index
    @orders = Order.all
  end

  def show
    
  end

  def new
     
  end

  def edit

  end

  def create
    @order = current_user.orders.build
    perform_transaction
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
    
  end

  def process_payment
    begin
      Order.transaction do
        @order.order_items.each do |item|
          item.product.update_attributes!(stock: item.product.stock - item.quantity)
        end
        details = order_params
        details.merge!({ status: "paid", transaction_id: SecureRandom.hex(10), payment_date: DateTime.now })
        @order.update_attributes!(details) 
        flash[:success] = "Your Payment transaction is successful. Order received successfully and will be delivered soon"
        redirect_to @order
      end
    rescue Exception => e
      flash[:danger] = e.message
      render 'payment'
    end
    OrderMailer.order_email(@order).deliver_later
  end

  private

  def order_params
    params.require(:order).permit(:status, :address, :country, :state, :zip_code, :card, :cvv, 
                                  :card_expiry_date, :payment_mode, :shipped_on, :delivered_on, 
                                  :payment_date)
  end

  def load_order
    @order = Order.find(params[:id]) rescue nil
    if @order.blank?
      flash[:danger] = "Order Does not exists"
      redirect_to profile_users_path
    end
  end

  def authorised_user
    unless @order.user == current_user || current_user.admin?
      flash[:danger] = "This order does not belongs to you"
      redirect_to profile_users_path 
    end
  end

  def is_valid_checkout?
    if current_user.cart.cart_items.count == 0
      flash[:danger] = "Your cart is empty, please add items"
      redirect_to display_carts_path
    else
      @order = Order.new
    end
  end

  def perform_transaction
    begin
      Order.transaction do              
        current_user.cart.cart_items.each do |item|
          details = { order_id: @order.id, product_id: item.product_id, price: item.product.price,
                     tax_rate: item.product.tax_rate, quantity: item.quantity, total_price: item.product.price * item.quantity * (1 + item.product.tax_rate / 100) }
          @order.order_items.build(details)
          item.destroy
        end
        details = order_params
        details.merge!({ amount: get_total_cost, tax: get_total_tax })
        @order.update_attributes!(details)
      end
    rescue Exception => e
      flash[:danger] = e.message
      render 'new'
    end
  end

  def get_total_cost
    total_cost = @order.order_items.inject(0){ |cost, item| cost += item.total_price}
  end

  def get_total_tax
    total_tax = @order.order_items.inject(0){ |cost, item| cost += item.price * item.tax_rate * item.quantity / 100 }
  end
end
