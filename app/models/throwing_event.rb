class ThrowingEvent < ApplicationRecord
  belongs_to :product
  belongs_to :all_event

  def self.create_event(options={})
    throwing_event=self.create(product: options[:product], amount: options[:amount])
    throwing_event.all_event.update_attribute(:sum, throwing_event.all_event.sum+options[:product].price_in*options[:amount])

    throwing_event.all_event.user.warehouses.change_product(product: options[:product], amount: -options[:amount])
  end

end
