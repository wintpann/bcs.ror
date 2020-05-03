module ApplicationHelper

  def plural(word)
    pluralize(2, word.to_s)[2..-1]
  end

  def timezones
    [
      {zone: 'UTC+14', value: 14},
      {zone: 'UTC+13', value: 13},
      {zone: 'UTC+12:45', value: 12.75},
      {zone: 'UTC+12', value: 12},
      {zone: 'UTC+11', value: 11},
      {zone: 'UTC+10:30', value: 10.5},
      {zone: 'UTC+10', value: 10},
      {zone: 'UTC+9:30', value: 9.5},
      {zone: 'UTC+9', value: 9},
      {zone: 'UTC+8:45', value: 8.75},
      {zone: 'UTC+8', value: 8},
      {zone: 'UTC+7', value: 7},
      {zone: 'UTC+6:30', value: 6.5},
      {zone: 'UTC+6', value: 6},
      {zone: 'UTC+5:45', value: 5.75},
      {zone: 'UTC+5:30', value: 5.5},
      {zone: 'UTC+5', value: 5},
      {zone: 'UTC+4:30', value: 4.5},
      {zone: 'UTC+4', value: 4},
      {zone: 'UTC+3', value: 3},
      {zone: 'UTC+2', value: 2},
      {zone: 'UTC+1', value: 1},
      {zone: 'UTC+0', value: 0},
      {zone: 'UTC-1', value: -1},
      {zone: 'UTC-2', value: -2},
      {zone: 'UTC-2:30', value: -2.5},
      {zone: 'UTC-3', value: -3},
      {zone: 'UTC-4', value: -4},
      {zone: 'UTC-5', value: -5},
      {zone: 'UTC-6', value: -6},
      {zone: 'UTC-7', value: -7},
      {zone: 'UTC-8', value: -8},
      {zone: 'UTC-9', value: -9},
      {zone: 'UTC-9:30', value: -9.5},
      {zone: 'UTC-10', value: -10},
      {zone: 'UTC-11', value: -11},
      {zone: 'UTC-12', value: -12}
    ]
  end

  def selected_timezone(timezone, user)
    return false if user.nil?

    return true if user.timezone==timezone[:value]
    return false
  end

  def sum(warehouses)
    sum=0
    warehouses.each { |item| sum+=item.amount*item.product.price_in }
    return sum
  end

  def any_working_sign(user)
    if user.active_working_employees.count==0
      return ''
    elsif user.active_working_employees.count==1
      return "(#{user.active_working_employees.count} работает)"
    elsif user.active_working_employees.count>1
      return "(#{user.active_working_employees.count} работают)"
    end
  end

  def get_links(model)
    links={}
    links[:left]=model.current_page-model.links_half
    links[:right]=model.current_page+model.links_half
    loop do
      if model.valid_page?(links[:left]) && model.valid_page?(links[:right])
        # everything is valid
        return links
      elsif model.valid_page?(links[:left]) && !model.valid_page?(links[:right]) && model.valid_page?(links[:left]-1)
        # right not valid, can move left
        links[:left]-=1
        links[:right]-=1
      elsif model.valid_page?(links[:right]) && !model.valid_page?(links[:left]) && model.valid_page?(links[:right]+1)
        # left not valid, can move right
        links[:left]+=1
        links[:right]+=1
      elsif model.valid_page?(links[:left]) && !model.valid_page?(links[:right]) && !model.valid_page?(links[:left]-1)
        # right not valid, cannot move left
        links[:right]-=1
      elsif model.valid_page?(links[:right]) && !model.valid_page?(links[:left]) && !model.valid_page?(links[:right]+1)
        # left not valid, cannot move right
        links[:left]+=1
      elsif !model.valid_page?(links[:right]) && !model.valid_page?(links[:left])
        # both not valid
        links[:left]+=1
        links[:right]-=1
      end
    end
  end

  def to_local(time)
    (time+@user.timezone.hour).to_s[0..-8]
  end

  def to_local_date(time)
    (time+@user.timezone.hour).to_s[0..-14]
  end

  def to_local_time(time)
    (time+@user.timezone.hour).to_s[11..-8]
  end

  def toggle_active(model)
    model.toggle!(:active)
  end

  def toggler_action(model)
    model.active? ? "Удалить" : "Восстановить"
  end

  def active_toggler_sign(state)
    return "Активен" if state
    return "Неактивен"
  end

  def confirm_message(model)
    item_type=model.class
    model.active? ? "Вы уверены? Будет помещено в <Удаленные>, вы сможете восстановить его позже" : "Вы собираетесь восстановить его"
  end
end
