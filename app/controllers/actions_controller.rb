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

  def get_employee
    @employee=Employee.find(params[:employee_id])
    @stocks=@employee.employee_stocks
    @stocks_products=warehouses_products(@stocks)
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

    if !@employee.active?
      flash[:danger]='Employee is inactive!'
      redirect_to user_path(params[:user_id])
    else

      if empty_product_params?(work_session_params)
        @errors=['Stuff must contain at least one product']
        render 'new_work_session'
      elsif more_than_there_is?(warehouses: @warehouses, product_params: work_session_params)
        @errors=['You can not give more than you have']
        render 'new_work_session'
      else
        if !@employee.working?
          start_work_session_event=@user.all_events.create(event_type: 'start_work_session')
          start_work_session_event.create_start_work_session_event(employee: @employee)
          @employee.start_work_session
        end

        event=@user.all_events.create(event_type: 'giving')
        create_new_giving(event: event, giving_params: work_session_params, employee: @employee)
        redirect_to user_employee_path(params[:user_id], params[:employee_id])
      end

    end
  end

  def end_work_session
    get_employee
  end

  def delete_work_session
    get_employee
    work_session_ends=work_session_ends?(end_work_session_params(@stocks_products))
    ending_params=ending_params(end_work_session_params(@stocks_products))

    if !@employee.working?
      flash[:danger]="The employee isn't working!"
      redirect_to user_path(params[:user_id])
    else

      if empty_product_params?(ending_params) && !work_session_ends
        @errors=['Stuff must contain at least one product']
        render 'end_work_session'
      elsif more_than_there_is?(warehouses: @stocks, product_params: ending_params)
        @errors=['You can not take more than there is']
        render 'end_work_session'
      elsif all_of?(warehouses: @stocks, product_params: ending_params) && !work_session_ends
        @errors=['You can not take all stuff without ending work session']
        render 'end_work_session'
      else
        # if !@employee.working?
        #   start_work_session_event=@user.all_events.create(event_type: 'start_work_session')
        #   start_work_session_event.create_start_work_session_event(employee: @employee)
        #   @employee.start_work_session
        # end
        #
        # event=@user.all_events.create(event_type: 'giving')
        # create_new_giving(event: event, giving_params: work_session_params, employee: @employee)
        # redirect_to user_employee_path(params[:user_id], params[:employee_id])
        if work_session_ends
          if !empty_product_params?(ending_params)
            # taking
          end
          # selling
          if @employee.fixed_rate>0 || @employee.interest_rate>0
            # salary
          end
          # end_work_session
        else
          event=@user.all_events.create(event_type: 'taking')
          create_new_taking(event: event, taking_params: ending_params, employee: @employee)
          redirect_to user_employee_path(params[:user_id], params[:employee_id])
        end

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

  def end_work_session_params(stocks_products)
    params.require(:end_work_session).permit(product_permitted_params(stocks_products).push('end_work_session'))
  end

end
