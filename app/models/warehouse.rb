class Warehouse < ApplicationRecord
  belongs_to :product
  belongs_to :user

  class << self

    def error
      @@error
    end

    def change_product(options={})
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

      changed_warehouse=self.find_by_product_name(options[:product].name)
      changed_warehouse.destroy if changed_warehouse.amount == 0
    end

    def have_product?(product)
      self.all.each do |warehouse|
        return warehouse if warehouse.product_id==product.id
      end

      return false
    end

    def find_by_product_name(product_name)
      self.all.each do |warehouse|
        return warehouse if warehouse.product.name==product_name
      end
      return nil
    end

  end

end
