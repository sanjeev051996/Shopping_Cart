class WelcomeController < ApplicationController

  skip_before_action :authenticate 
  skip_before_action :admin_user?
   
  def index
    session[:visitors] ||= 0
    session[:visitors] += 1
  end
end
