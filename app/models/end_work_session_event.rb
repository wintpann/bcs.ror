class EndWorkSessionEvent < ApplicationRecord
  belongs_to :all_event
  belongs_to :employee
end
