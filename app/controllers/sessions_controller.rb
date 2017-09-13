class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    # binding.pry | byebug
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = 'U have successfully logged in'
      redirect_to current_user
    else
      flash[:danger] = 'Invalid email/password combination'
  	  render 'new'
    end
  end
  
  def destroy
  	log_out
    redirect_to root_url
  end
end
