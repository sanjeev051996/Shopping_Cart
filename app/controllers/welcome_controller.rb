class WelcomeController < ApplicationController

  skip_before_action :authenticate 
  skip_before_action :admin_user?
   
  def index
  end

end
