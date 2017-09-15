class UsersController < ApplicationController

  skip_before_action :authenticate, only: [:new, :create]
  skip_before_action :admin_user?, except: [:index, :destroy, :show]
  before_action :load_user, only: [:edit, :update, :show, :destroy]
  
  def index
    @users = User.all
  end

  def show
    
  end

  def new
    @user = User.new
  end

  def edit
    
  end

  def create
    @user = User.new(user_params)
    if @user.save
    	log_in @user
      @user.create_cart
    	flash[:success] = "Welcome to the Sample App!"
      redirect_to profile_path
    else
      render 'new'
    end
  end

  def update
    if @user.update_attributes(user_params) 
    	flash[:success] = "Profile updated"
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User Removed Successfully"
    redirect_to users_path
  end

  def profile
    @user = current_user
    render 'show'
  end

  def profile_settings
    @user = current_user
    render '_update_form'
  end

  private

  def load_user
    @user = current_user unless current_user.admin?
    @user = User.find(params[:id]) if current_user.admin? rescue nil
    if @user.blank?
      flash[:danger] = "User does not exits"
      redirect_to root_url 
    end
    @user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :contact, :dob, :address, :country, :state)
  end
end
