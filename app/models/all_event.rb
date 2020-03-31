class AllEvent < ApplicationRecord
  belongs_to :user
  has_many :shopping_events
end
