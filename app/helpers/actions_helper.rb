module ActionsHelper

  def empty_purchase?(shopping_params)
    at_least_one_product=false
    shopping_params.each { |key, value| at_least_one_product=true if value.strip.to_i > 0 }
    return (at_least_one_product ? false : true)
  end

  def to_hash_of_arrays_by_date(all_events)
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
    @events
  end

  def warehouses_products(warehouses)
    products=[]
    warehouses.each do |warehouse|
      products << warehouse.product
    end
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
    options[:shopping_params].each do |key, value|
      if value.to_i > 0
        product=Product.find_by(name: key)
        options[:event].shopping_events.create_event(product: product, amount: value.to_i)
      end
    end
  end

  def create_new_throwing(options={})
    options[:throwing_params].each do |key, value|
      if value.to_i > 0
        product=Product.find_by(name: key)
        options[:event].throwing_events.create_event(product: product, amount: value.to_i)
      end
    end
  end

  def create_new_giving(options={})
    options[:giving_params].each do |key, value|
      if value.to_i > 0
        product=Product.find_by(name: key)
        options[:event].giving_events.create_event(product: product, amount: value.to_i, employee: options[:employee])
      end
    end
  end

  def create_new_taking(options={})
    options[:taking_params].each do |key, value|
      if value.to_i > 0
        product=Product.find_by(name: key)
        options[:event].taking_events.create_event(product: product, amount: value.to_i, employee: options[:employee])
      end
    end
  end

  def create_new_selling(options={})
    options[:employee].employee_stocks do |stock|
      options[:selling_event].selling_events.create_event(product: stock.product, amount: stock.amount, employee: stock.employee)
    end
    options[:employee].employee_stocks.destroy_all
  end

  def create_new_employee_salary(options={})
    options[:employee_salary_event].create_employee_salary_event(employee: options[:employee], sum: (options[:selling_event].sum.to_f*options[:employee].interest_rate.to_f/100)+options[:employee].fixed_rate)
  end

  def create_new_end_work_session(options={})
    options[:end_work_session_event].create_end_work_session_event(employee: options[:employee])
    options[:employee].end_work_session
  end

  def product_permitted_params(products)
    permitted_params=[]
    products.each do |product|
      permitted_params.push product.name
    end
    return permitted_params
  end

end
