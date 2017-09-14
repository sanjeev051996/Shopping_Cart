class UsersController < ApplicationController

  before_action :authenticate, except: [:new, :create]
  before_action :authorised_user, only: [:show, :edit, :update]
  before_action :admin_user, only: [:index, :destroy]
  before_action :load_user, except: [:index, :new, :create]
  
  def index
    @users = User.all
  end

  def show
    
  end

  def new
    @user = User.new
  end

  def edit
    #binding.pry
  end

  def create
    #binding.pry
    @user = User.new(user_params)
    if @user.save
    	log_in @user
      @user.create_cart
    	flash[:success] = "Welcome to the Sample App!"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def update
    #binding.pry
    if @user.update_attributes(user_params) 
    	flash[:success] = "Profile updated"
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User Removed Successfully"
    redirect_to users_path
  end

  private

  def load_user
  	@user = User.find(params[:id]) rescue nil
    if @user.blank?
      flash[:danger] = "User does not exits"
      redirect_to current_user
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :contact, :dob, :address, :country, :state)
  end

  def authorised_user
    #binding.pry
    user = User.find(params[:id]) rescue nil
    if user.blank?
      flash[:danger] = "User does not exits"
    end
    unless current_user?(user) || current_user.admin?
      flash[:danger] = "U are not authorised for this action." 
    end
  end
end
