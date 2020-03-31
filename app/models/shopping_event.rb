class ShoppingEvent < ApplicationRecord
  belongs_to :product
  belongs_to :all_event

  def self.create_event(options={})
    shopping_event=self.create(product: options[:product], amount: options[:amount])
    shopping_event.all_event.update_attribute(:sum, event.all_event.sum+options[:product].price_in*options[:amount])

    shopping_event.all_event.user.warehouses.change_product(product: options[:product], amount: options[:amount])
  end
end
