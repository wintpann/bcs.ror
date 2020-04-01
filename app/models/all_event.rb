class AllEvent < ApplicationRecord
  belongs_to :user
  has_many :shopping_events
  has_many :throwing_events
  has_many :giving_events
  has_many :start_work_session_events
end
