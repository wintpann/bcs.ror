class TakingEvent < ApplicationRecord
  belongs_to :product
  belongs_to :employee
  belongs_to :all_event
end
