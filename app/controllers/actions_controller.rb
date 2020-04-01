class ActionsController < ApplicationController
  include ActionsHelper

  before_action :authenticate_user!
  before_action :correct_user!

  before_action do
    @user=User.find(params[:user_id])
    @products=@user.products
    @active_products=@user.active_products
    @warehouse_products=warehouse_products(@user)
    @warehouses=@user.warehouses
  end

  def warehouse
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
    if empty_purchase?(shopping_params)
      @errors=['Purchase must contain at least one product']
      render 'new_shopping'
      return
    end

    event=@user.all_events.create(event_type: 'shopping')
    create_new_shopping(event: event, shopping_params: shopping_params)
    redirect_to user_warehouse_path
  end

  def new_throwing
  end

  def create_throwing

  end


  def shopping_params
    params.require(:shopping_event).permit(product_permitted_params(@active_products))
  end

end
