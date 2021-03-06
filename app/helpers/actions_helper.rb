module ActionsHelper

  def event_types
    [
      {name: "Все", type: 'all'},
      {name: 'Закупка', type: 'shopping'},
      {name: 'Начало рабочей сессии', type: 'start_work_session'},
      {name: 'Списание товара', type: 'throwing'},
      {name: 'Передача товара', type: 'giving'},
      {name: 'Конец рабочей сессии', type: 'end_work_session'},
      {name: 'Продажа товара', type: 'selling'},
      {name: 'Получение товара', type: 'taking'},
      {name: 'Зарплата', type: 'employee_salary'},
      {name: 'Другой расход', type: 'other_expense'},
      {name: 'Транспортный расход', type: 'fare'},
      {name: 'Расход на оборудование', type: 'equipment'},
      {name: 'Налог', type: 'tax'}
    ]
  end

  def type_selected(s)
    return true if params[:search][:type]==s[:type]
  end

  def employee_selected(e)
    return true if params[:search][:employee]==e.id.to_s
  end

  def sort_selected(str)
    return true if params[:search][:sort]==str
  end

  def empty_purchase?(shopping_params)
    at_least_one_product=false
    shopping_params.each { |key, value| at_least_one_product=true if value.strip.to_i > 0 }
    return (at_least_one_product ? false : true)
  end

  def by_date(all_events)
    return nil if !all_events.any?
    @events=[]

    old_date=to_local_date(all_events.first.created_at)
    common_events=[]

    all_events.each do |event|
      new_date=to_local_date(event.created_at)
      if event==all_events.last
        if new_date==old_date
          common_events << event
          @events << {date: old_date, events: common_events}
        else
          @events << {date: old_date, events: common_events}
          @events << {date: new_date, events: [event]}
        end
      else
        if new_date==old_date
          common_events << event
        else
          @events << {date: old_date, events: common_events}
          common_events=[]
          old_date=new_date
          common_events << event
        end
      end
    end
    @events
  end

  def warehouses_products(warehouses)
    products=[]
    warehouses.each { |warehouse| products << warehouse.product }
    return products
  end

  def empty_product_params?(product_params)
    product_params.each { |key, value| return false if value.to_i > 0 }
    return true
  end

  def ending_params(ending_params)
    ending_params.delete('end_work_session')
    return ending_params
  end

  def work_session_ends?(params)
    return true if params['end_work_session']=='1'
    return false
  end

  def more_than_there_is?(options={})
    options[:product_params].each do |key, value|
      if value.to_i > options[:warehouses].find_by_product_name(key).amount
        return true
      end
    end
    return false
  end

  def all_of?(options={})
    options[:product_params].each do |key, value|
      if value.to_i != options[:warehouses].find_by_product_name(key).amount
        return false
      end
    end
    return true
  end

  def create_new_shopping(options={})
    options[:params].each do |key, value|
      if value.to_i > 0
        product=Product.find_by(name: key)
        options[:event].shopping_events.create_event(product: product, amount: value.to_i)
      end
    end
    options[:event].user.update_attribute(:earned, options[:event].user.earned-options[:event].reload.sum)
  end

  def create_new_throwing(options={})
    options[:params].each do |key, value|
      if value.to_i > 0
        product=Product.find_by(name: key)
        options[:event].throwing_events.create_event(product: product, amount: value.to_i)
      end
    end
    options[:event].user.update_attribute(:throwed, options[:event].user.throwed-options[:event].reload.sum)
  end

  def create_new_giving(options={})
    options[:params].each do |key, value|
      if value.to_i > 0
        product=Product.find_by(name: key)
        options[:event].giving_events.create_event(product: product, amount: value.to_i, employee: options[:employee])
      end
    end
    options[:event].update_attribute(:employee_id, options[:employee].id)
  end

  def create_new_taking(options={})
    options[:params].each do |key, value|
      if value.to_i > 0
        product=Product.find_by(name: key)
        options[:event].taking_events.create_event(product: product, amount: value.to_i, employee: options[:employee])
      end
    end
    options[:event].update_attribute(:employee_id, options[:employee].id)
  end

  def was_selling?(user)
    return true if user.all_events.last.event_type=='selling'
    return false
  end

  def has_single_salary?(employee)
    return true if employee.fixed_rate>0 && employee.interest_rate>0
    return false
  end

  def create_new_selling(options={})
    options[:employee].employee_stocks.each do |stock|
      options[:event].selling_events.create_event(product: stock.product, amount: stock.amount, employee: stock.employee)
    end
    options[:employee].employee_stocks.destroy_all
    options[:event].update_attribute(:employee_id, options[:employee].id)
    options[:event].user.update_attribute(:earned, options[:event].user.earned+options[:event].reload.sum)
  end

  def create_new_employee_salary(options={})
    salary=(options[:employee].fixed_rate+options[:employee].interest_rate.to_f/100*options[:selling_event].sum)
    head_salary_event=options[:salary_event].create_employee_salary_event(employee: options[:employee], sum: salary )
    options[:salary_event].update_attribute(:sum, head_salary_event.sum)
    options[:salary_event].update_attribute(:employee_id, options[:employee].id)
    options[:salary_event].user.update_attribute(:earned, options[:salary_event].user.earned-options[:salary_event].reload.sum)
  end

  def create_new_end_work_session(options={})
    options[:event].create_end_work_session_event(employee: options[:employee])
    options[:employee].end_work_session
    options[:event].update_attribute(:employee_id, options[:employee].id)
  end

  def create_new_start_work_session(options={})
    options[:event].create_start_work_session_event(employee: options[:employee])
    options[:employee].start_work_session
    options[:event].update_attribute(:employee_id, options[:employee].id)
  end

  def temp_event(options={})
    options[:class].new(description: options[:params][:description], sum: options[:params][:sum], all_event: AllEvent.new(event_type: 'temp'))
  end

  def product_permitted_params(products)
    permitted_params=[]
    products.each do |product|
      permitted_params.push product.name
    end
    return permitted_params
  end

end
