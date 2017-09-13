class ApplicationController < ActionController::Base
	
  protect_from_forgery with: :exception
  include SessionsHelper
  
  def admin_user
    unless current_user.admin?
      flash[:danger] = "U are not authorised for this action."
      redirect_to(current_user) 
    end
  end

  def authenticate
    unless logged_in?
      flash[:danger] = "Please log in." 
      redirect_to login_url
    end
  end
  
end
