class EmployeeStock < ApplicationRecord
  belongs_to :product
  belongs_to :employee

  class << self

    def error
      @@error
    end

    def change_product(options={})
      if (stock=self.have_product?(options[:product]))
        if (stock.amount+options[:amount]) < 0
          @error="There cannot be a negative number of products"
          return
        end
        stock.update_attribute(:amount, stock.amount+options[:amount])
      else
        if options[:amount] < 0
          @@error="There cannot be a negative number of products"
          return
        end
        self.create!(amount: options[:amount], product: options[:product])
      end
    end

    def have_product?(product)
      self.all.each do |stock|
        return stock if stock.product_id==product.id
      end

      return false
    end

  end

end
