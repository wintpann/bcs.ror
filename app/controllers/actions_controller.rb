class ActionsController < ApplicationController
  include ActionsHelper

  before_action :authenticate_user!
  before_action :active_user!
  before_action :correct_user!
  before_action :admin_user!, only: :toggle_user

  before_action do
    @user=User.find(params[:user_id])
    @products=@user.products
    @active_products=@user.active_products
    @warehouses=@user.warehouses
    @warehouses_products=warehouses_products(@warehouses)
  end

  def stat
  end

  def get_employee_with_stocks
    @employee=Employee.find(params[:employee_id])
    @stocks=@employee.employee_stocks
    @stocks_products=warehouses_products(@stocks)
  end

  def warehouse
  end

  def events

    @all_events=@user.all_events
    @all_events.paginate(params[:page])
    search=params[:search]

    if @all_events.empty?
      flash[:alert]="У вас еще нет событий"
      redirect_to user_path(params[:user_id])
      return
    end

    if AllEvent.bad_page? || !params[:search] || params[:search][:date_from].empty? || params[:search][:date_to].empty?
      redirect_to user_events_path(params[:user_id], page: 1, search:{type: 'all', employee: 'all', date_from: AllEvent.first.created_at.strftime('%Y-%m-%d'), date_to: AllEvent.last.created_at.strftime('%Y-%m-%d'), sort: 'date_desc'})
      return
    end

    if search[:type]!='all'
      @all_events=@all_events.where(event_type: search[:type])
    end

    if search[:employee]!='all'
      @all_events=@all_events.where(employee_id: search[:employee].to_i)
    end

    @all_events=@all_events.where('created_at >= ? and created_at <= ?', search[:date_from], search[:date_to].to_date+1.day)

    if search[:sort]=='date_desc'
      @all_events=@all_events.order(created_at: :desc)
    elsif search[:sort]=='date_asc'
      @all_events=@all_events.order(created_at: :asc)
    elsif search[:sort]=='sum_desc'
      @all_events=@all_events.order(sum: :desc)
    elsif search[:sort]=='sum_asc'
      @all_events=@all_events.order(sum: :asc)
    end

    @events=@all_events.paginate(params[:page])
    @events=( @events ? by_date(@events) : nil )
  end

  def event
    @event=@user.all_events.find(params[:id])
  end

  def new_shopping
  end

  def create_shopping
    if empty_purchase?(shopping_params)
      @errors=['Покупка должна содержать хотя бы один продукт']
      render 'new_shopping'
      return
    end

    head_shopping_event=@user.all_events.create(event_type: 'shopping')
    create_new_shopping(event: head_shopping_event, params: shopping_params)
    redirect_to user_warehouse_path
  end

  def new_throwing
  end

  def create_throwing
    if empty_product_params?(throwing_params)
      @errors=['Списание должно содержать хотя бы один продукт']
      render 'new_throwing'
    elsif more_than_there_is?(warehouses: @warehouses, product_params: throwing_params)
      @errors=['Вы не можете списать больше чем есть в наличии']
      render 'new_throwing'
    else
      head_throwing_event=@user.all_events.create(event_type: 'throwing')
      create_new_throwing(event: head_throwing_event, params: throwing_params)
      redirect_to user_warehouse_path
    end
  end

  def new_work_session
    @employee=Employee.find(params[:employee_id])
  end

  def create_work_session
    @employee=Employee.find(params[:employee_id])

    if !@employee.active?
      flash[:danger]='Работник удален!'
      redirect_to user_path(params[:user_id])
      return
    end

    if empty_product_params?(work_session_params)
      @errors=['Должен быть хотя бы один продукт']
      render 'new_work_session'
      return
    end

    if more_than_there_is?(warehouses: @warehouses, product_params: work_session_params)
      @errors=['Вы не можете дать больше чем есть в наличии']
      render 'new_work_session'
      return
    end

    if !@employee.working?
      head_start_work_session_event=@user.all_events.create(event_type: 'start_work_session')
      create_new_start_work_session(employee: @employee, event: head_start_work_session_event)
    end

    head_giving_event=@user.all_events.create(event_type: 'giving')
    create_new_giving(event: head_giving_event, params: work_session_params, employee: @employee)
    redirect_to user_employee_path(params[:user_id], params[:employee_id])
  end

  def end_work_session
    get_employee_with_stocks
  end

  def delete_work_session
    get_employee_with_stocks
    work_session_ends=work_session_ends?(end_work_session_params(@stocks_products))
    ending_params=ending_params(end_work_session_params(@stocks_products))

    if !@employee.working?
      flash[:danger]="Этот работник не работает!"
      redirect_to user_path(params[:user_id])
      return
    end

    if empty_product_params?(ending_params) && !work_session_ends
      @errors=['Должно содержать хотя бы один продукт']
      render 'end_work_session'
      return
    end

    if more_than_there_is?(warehouses: @stocks, product_params: ending_params)
      @errors=['Вы не можете взять больше чем есть']
      render 'end_work_session'
      return
    end

    if all_of?(warehouses: @stocks, product_params: ending_params) && !work_session_ends
      @errors=['Закончите сессию если хотите взять весь товар']
      render 'end_work_session'
      return
    end

    if !empty_product_params?(ending_params)
      head_taking_event=@user.all_events.create(event_type: 'taking')
      create_new_taking(event: head_taking_event, params: ending_params, employee: @employee)
      @stocks.reload
    end

    if !work_session_ends
      redirect_to user_employee_path(params[:user_id], params[:employee_id])
      return
    end

    if @stocks.any?
      head_selling_event=@user.all_events.create(event_type: 'selling')
      create_new_selling(event: head_selling_event, employee: @employee)
      head_selling_event.reload
    end

    if was_selling?(@user) && has_single_salary?(@employee)
      head_employee_salary_event=@user.all_events.create(event_type: 'employee_salary')
      create_new_employee_salary(salary_event: head_employee_salary_event, selling_event: head_selling_event, employee: @employee)
    end

    head_end_work_session_event=@user.all_events.create(event_type: 'end_work_session')
    create_new_end_work_session(employee: @employee, event: head_end_work_session_event)
    redirect_to user_employee_path(params[:user_id], params[:employee_id])
  end

  def new_fare
  end

  def create_fare
    fare_params=expense_params('new_fare')
    temp_event=temp_event(class: FareEvent, params: fare_params)
    if temp_event.valid?
      head_fare_event=@user.all_events.create(event_type: 'fare')
      head_fare_event.create_fare(description: fare_params[:description], sum: fare_params[:sum])
      redirect_to user_events_path
    else
      @errors=temp_event.errors.full_messages
      render 'new_fare'
    end
  end

  def new_tax
  end

  def create_tax
    tax_params=expense_params('new_tax')
    temp_event=temp_event(class: TaxEvent, params: tax_params)
    if temp_event.valid?
      head_tax_event=@user.all_events.create(event_type: 'tax')
      head_tax_event.create_tax(description: tax_params[:description], sum: tax_params[:sum])
      redirect_to user_events_path
    else
      @errors=temp_event.errors.full_messages
      render 'new_tax'
    end
  end

  def new_equipment
  end

  def create_equipment
    equipment_params=expense_params('new_equipment')
    temp_event=temp_event(class: EquipmentEvent, params: equipment_params)
    if temp_event.valid?
      head_equipment_event=@user.all_events.create(event_type: 'equipment')
      head_equipment_event.create_equipment(description: equipment_params[:description], sum: equipment_params[:sum])
      redirect_to user_events_path
    else
      @errors=temp_event.errors.full_messages
      render 'new_equipment'
    end
  end

  def new_other_expense
  end

  def create_other_expense
    other_expense_params=expense_params('new_other_expense')
    temp_event=temp_event(class: OtherExpenseEvent, params: other_expense_params)
    if temp_event.valid?
      head_other_expense_event=@user.all_events.create(event_type: 'other_expense')
      head_other_expense_event.create_other_expense(description: other_expense_params[:description], sum: other_expense_params[:sum])
      redirect_to user_events_path
    else
      @errors=temp_event.errors.full_messages
      render 'new_other_expense'
    end
  end

  def toggle_user
    User.find(params[:user_id]).toggle!(:active)
    redirect_to users_path
  end

  def expense_params(type)
    params.require(type).permit(:sum, :description)
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
