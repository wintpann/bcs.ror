class TakingEvent < ApplicationRecord
  belongs_to :product
  belongs_to :employee
  belongs_to :all_event

  def self.create_event(options={})
    taking_event=self.create(product: options[:product], amount: options[:amount], employee: options[:employee])
    taking_event.all_event.update_attribute(:sum, taking_event.all_event.sum+options[:amount]*options[:product].price_in)

    options[:employee].employee_stocks.change_product(product: options[:product], amount: -options[:amount])

    options[:employee].user.warehouses.change_product(product: options[:product], amount: options[:amount])
  end

end
