class CartsController < ApplicationController

  def show
    @cart = current_user.cart
  end

  def destroy
  	current_user.cart.destroy
  	redirect_to current_user
  end
end
