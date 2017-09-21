class UserMailer < ApplicationMailer

  default from: 'notifications@shopping_cart'
 
  def welcome_email(user)
    @user = user
    @url  = login_users_url #To use url's set host globally and use _url instead of _path
    mail(to: @user.email, subject: 'Welcome to Shopping Cart')
  end
end
