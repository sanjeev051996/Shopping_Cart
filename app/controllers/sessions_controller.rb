class SessionsController < ApplicationController
 
  skip_before_action :admin_user? 
  skip_before_action :authenticate, except: :destroy
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    # binding.pry | byebug
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = 'You have successfully logged in'
      redirect_to profile_path 
    else
      flash[:danger] = 'Invalid email/password combination'
  	  render 'new'
    end
  end
  
  def destroy
  	log_out
    flash[:success] = "You have Successfully logged out"
    redirect_to root_url
  end
end
