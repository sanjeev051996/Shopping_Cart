class OrderItemsController < ApplicationController

  def destroy
    @order_item = orderItem.find(params[:id]) rescue nil
    @order_item.destroy
  end 
end
