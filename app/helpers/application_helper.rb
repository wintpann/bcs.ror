module ApplicationHelper

  def plural(word)
    pluralize(2, word.to_s)[2..-1]
  end

  def sum(warehouses)
    sum=0
    warehouses.each { |item| sum+=item.amount*item.product.price_in }
    return sum
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
    time.localtime.to_s[0...-9]
  end

  def to_local_time(time)
    time.localtime.to_s[11...-9]
  end

  def toggle_active(model)
    model.toggle!(:active)
  end

  def toggler_action(model)
    model.active? ? "Удалить" : "Восстановить"
  end

  def confirm_message(model)
    item_type=model.class
    model.active? ? "Вы уверены? Будет помещено в <Удаленные>, вы сможете восстановить его позже" : "Вы собираетесь восстановить его"
  end
end
