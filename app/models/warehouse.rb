class Warehouse < ApplicationRecord

  def self.error
    @@error
  end

  belongs_to :product
  belongs_to :user

  def self.change_product(options={})
    if (warehouse=self.have_product?(options[:product]))
      if (warehouse.amount+options[:amount]) < 0
        @@error="There cannot be a negative number of products"
        return
      end
      warehouse.update_attribute(:amount, warehouse.amount+options[:amount])
    else
      if options[:amount] < 0
        @@error="There cannot be a negative number of products"
        return
      end
      self.create!(amount: options[:amount], product: options[:product])
    end
  end

  def self.have_product?(product)
    self.all.each do |warehouse|
      return warehouse if warehouse.product_id==product.id
    end

    return false
  end

end
