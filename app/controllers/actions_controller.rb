class ActionsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!

  before_action do
    @user=User.find(params[:user_id])
    @products=@user.products
  end

  def warehouse
    @warehouses=@user.warehouses
  end

  def new_shopping

  end

  def create_shopping
    at_least_one_product=false
    shopping_params.each { |key, value| at_least_one_product=true if value.strip.to_i > 0 }
    if !at_least_one_product
      @errors=['Purchase must contain at least one product']
      render 'new_shopping'
      return
    end

    @event=@user.all_events.create(event_type: 'shopping')
    shopping_params.each do |key, value|
      if value.to_i > 0
        @event.shopping_events.create(product: Product.find_by(name: key), amount: value.to_i)
      end
    end
  end


  def shopping_params
    permitted_params=[]
    @products.each do |product|
      permitted_params.push product.name
    end
    params.require(:shopping_event).permit(permitted_params)
  end

end
