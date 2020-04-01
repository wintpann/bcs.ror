class ActionsController < ApplicationController
  include ActionsHelper

  before_action :authenticate_user!
  before_action :correct_user!

  before_action do
    @user=User.find(params[:user_id])
    @products=@user.products
    @active_products=@user.active_products
    @warehouses=@user.warehouses
    @warehouses_products=warehouses_products(@warehouses)
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
    if empty_product_params?(throwing_params)
      @errors=['Throw must contain at least one product']
      render 'new_throwing'
    elsif more_than_there_is?(warehouses: @warehouses, product_params: throwing_params)
      @errors=['You can not throw more than you have']
      render 'new_throwing'
    else
      event=@user.all_events.create(event_type: 'throwing')
      create_new_throwing(event: event, throwing_params: throwing_params)
      redirect_to user_warehouse_path
    end
  end

  def new_work_session
    @employee=Employee.find(params[:employee_id])
  end

  def create_work_session
    @employee=Employee.find(params[:employee_id])

    if !@employee.active
      flash[:danger]='Employee is already working or inactive!'
      redirect_to user_path(params[:user_id])
    else

      if empty_product_params?(work_session_params)
        @errors=['Stuff must contain at least one product']
        render 'new_work_session'
      elsif more_than_there_is?(warehouses: @warehouses, product_params: work_session_params)
        @errors=['You can not give more than you have']
        render 'new_work_session'
      else
        @employee.start_work_session

        event=@user.all_events.create(event_type: 'giving')
        create_new_giving(event: event, giving_params: work_session_params, employee: @employee)
        redirect_to user_events_path
      end

    end
  end

  def shopping_params
    params.require(:shopping_event).permit(product_permitted_params(@active_products))
  end

  def throwing_params
    params.require(:throwing_event).permit(product_permitted_params(@warehouses_products))
  end

  def work_session_params
    params.require(:work_session).permit(product_permitted_params(@warehouses_products))
  end

end
