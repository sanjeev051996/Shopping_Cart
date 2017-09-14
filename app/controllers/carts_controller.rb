class CartsController < ApplicationController

  before_action :valid_user, only: [:show]
  before_action :admin_user, only: :destroy

  def show
    @cart = current_user.cart
  end

  def destroy
  	current_user.cart.destroy
  	redirect_to current_user
  end

  private

  def valid_user
    cart = Cart.find(params[:id]) rescue nil
    unless cart.user == current_user
      flash[:danger] = "U are not authorised for this action"
      redirect_to current_user
    end
  end

end
