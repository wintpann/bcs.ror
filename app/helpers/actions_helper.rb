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

  def product_permitted_params(products)
    permitted_params=[]
    products.each do |product|
      permitted_params.push product.name
    end
    return permitted_params
  end

end
