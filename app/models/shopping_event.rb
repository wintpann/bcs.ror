class ShoppingEvent < ApplicationRecord
  belongs_to :product
  belongs_to :all_event
end
