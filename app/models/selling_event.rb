class SellingEvent < ApplicationRecord
  belongs_to :product
  belongs_to :all_event
  belongs_to :employee
end
