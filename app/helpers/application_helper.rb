module ApplicationHelper

  def plural(word)
    pluralize(2, word.to_s)[2..-1]
  end

  def get_links(model)
    links={}
    
    return links
  end

  def to_local(time)
    time.localtime.to_s[0...-9]
  end

  def to_local_time(time)
    time.localtime.to_s[11...-9]
  end

  def toggle_active(model)
    model.toggle!(:active)
  end

  def toggler_action(model)
    model.active? ? "Delete #{model.class}" : "Restore #{model.class}"
  end

  def confirm_message(model)
    item_type=model.class
    model.active? ? "Are you sure? #{item_type} will placed in <Inactive #{plural(item_type)}>, so you can restore it later" : "You are going to restore #{item_type}"
  end
end
