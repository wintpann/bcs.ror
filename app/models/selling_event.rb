class SellingEvent < ApplicationRecord
  belongs_to :product
  belongs_to :all_event
  belongs_to :employee

  def self.create_event(options={})
    selling_event=self.create(product: options[:product], amount: options[:amount], employee: options[:employee])
    selling_event.all_event.update_attribute(:sum, selling_event.all_event.sum+options[:amount]*options[:product].price_out)
  end
end
