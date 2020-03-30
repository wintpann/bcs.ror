class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
    @product=User.find(params[:user_id]).products.find(params[:id])
  end

  def index
    @products=User.find(params[:user_id]).products
  end
end
