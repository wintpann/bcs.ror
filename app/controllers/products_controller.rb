class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :active_user!
  before_action :correct_user!

  def new
    @product=User.find(params[:user_id]).products.new
  end

  def create
    @product=User.find(params[:user_id]).products.new(product_params)

    if @product.save
      flash[:success]='Продукт добавлен'
      redirect_to user_product_path( params[:user_id], @product.id )
    else
      @errors=@product.errors.full_messages
      render 'new'
    end
  end

  def edit
    @product=User.find(params[:user_id]).products.find(params[:id])
  end

  def update
    @product=User.find(params[:user_id]).products.find(params[:id])
    if @product.update(product_params)
      flash[:success]='Продукт обновлен'
      redirect_to user_product_path
    else
      @errors=@product.errors.full_messages
      render 'edit'
    end
  end

  def show
    @product=User.find(params[:user_id]).products.find(params[:id])
  end

  def index
    @active_products=User.find(params[:user_id]).active_products
  end

  def inactive
    @inactive_products=User.find(params[:user_id]).inactive_products
  end

  def destroy
    product=Product.find(params[:id])
    toggle_active(product)
    flash[:success] = (product.active? ? 'Продукт восстановлен' : 'Продукт удален')
    redirect_to user_products_path
  end

  private

  def product_params
    params.require(:product).permit(:price_in, :price_out, :name)
  end

end
