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
    all_events=@user.all_events.all
    @events={}

    old_date=to_local(all_events.first.created_at)[0..-7]
    common_events=[]

    all_events.each do |event|
      new_date=to_local(event.created_at)[0..-7]
      if event==all_events.last
        if new_date==old_date
          common_events << event
          @events["#{old_date}"]=common_events
        else
          @events["#{old_date}"]=common_events
          @events["#{new_date}"]=[event]
        end
      else
        if new_date==old_date
          common_events << event
        else
          @events["#{old_date}"]=common_events
          common_events=[]
          old_date=new_date
          common_events << event
        end
      end
    end
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
