class ShoppingEvent < ApplicationRecord
  belongs_to :product
  belongs_to :all_event

  def self.create_event(options={})
    event=self.create(product: options[:product], amount: options[:amount])
    event.all_event.update_attribute(:sum, event.all_event.sum+options[:product].price_in*options[:amount])

    event.all_event.user.warehouses.change_product(product: options[:product], amount: options[:amount])
  end
end
