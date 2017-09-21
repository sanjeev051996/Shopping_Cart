class ProductsController < ApplicationController

  skip_before_action :admin_user?, only: [:index, :show]
  before_action :load_product, except: [:index, :new, :create]
  
  def index
    @products = Product.all
  end

  def show
    
  end

  def new
    @product = Product.new
  end

  def edit
    
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Product created!"
      redirect_to @product
    else
      render 'new'
    end
  end

  def update
    if @product.update_attributes(product_params) 
      flash[:success] = "Product updated!"
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  private

  def load_product
    @product = Product.find(params[:id]) rescue nil
    if @product.blank?
      flash[:danger] = "product does not exits"
      redirect_to products_path
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :tax_rate, 
                                    :cod, :stock, :shipping_charge_rate)
  end
end
