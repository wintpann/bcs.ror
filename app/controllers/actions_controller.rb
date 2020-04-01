class ActionsController < ApplicationController
  include ActionsHelper

  before_action :authenticate_user!
  before_action :correct_user!

  before_action do
    @user=User.find(params[:user_id])
    @products=@user.products
  end

  def warehouse
    @warehouses=@user.warehouses
  end

  def events
    all_events=@user.all_events.all.order(created_at: :desc)
    @events=to_hash_of_arrays_by_date(all_events)
  end

  def event
    @event=@user.all_events.find(params[:id])
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
        product=Product.find_by(name: key)
        @event.shopping_events.create_event(product: product, amount: value.to_i)
      end
    end
    redirect_to user_warehouse_path
  end


  def shopping_params
    permitted_params=[]
    @products.each do |product|
      permitted_params.push product.name
    end
    params.require(:shopping_event).permit(permitted_params)
  end

end
