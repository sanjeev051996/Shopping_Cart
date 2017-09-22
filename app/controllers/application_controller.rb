class ApplicationController < ActionController::Base
	
  protect_from_forgery with: :exception
  include UsersSession

  before_action :authenticate #To check wheather user is logged in
  before_action :admin_user? #To check wheather user is admin
  
   def authenticate
    unless logged_in?
      flash[:danger] = "Please log in." 
      redirect_to login_users_url
    end
  end

  def admin_user?
    unless current_user.admin?
      flash[:danger] = "You are not authorised for this action."
      redirect_to profile_users_path 
    end
  end

  helper_method :current_user
end
