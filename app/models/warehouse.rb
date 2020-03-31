class Warehouse < ApplicationRecord

  def self.error
    @@error
  end

  belongs_to :product
  belongs_to :user

  def self.change_product(product_to_change, amount_to_change)
    if (warehouse=self.have_product?(product_to_change))
      if (warehouse.amount+amount_to_change) < 0
        @@error="There cannot be a negative number of products"
        return
      end
      warehouse.update_attribute(:amount, warehouse.amount+amount_to_change)
    else
      if amount_to_change < 0
        @@error="There cannot be a negative number of products"
        return
      end
      self.create!(amount: amount_to_change, product: product_to_change)
    end
  end

  def self.have_product?(product)
    self.all.each do |warehouse|
      return warehouse if warehouse.product_id==product.id
    end

    return false
  end

end
