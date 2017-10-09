class OrderMailer < ApplicationMailer

  default from: 'notifications@shopping_cart'

  def order_email(order)
    @order = order
    @user = order.user
    @url  = order_url(order) #To use url's set host globally and use _url instead of _path
    mail(to: @user.email, subject: 'Order confirmation')
  end
end
