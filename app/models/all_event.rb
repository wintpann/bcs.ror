class AllEvent < ApplicationRecord
  belongs_to :user
  has_many :shopping_events
  has_many :throwing_events
  has_many :giving_events
  has_many :selling_events
  has_many :taking_events
  has_one :start_work_session_event
  has_one :end_work_session_event
  has_one :employee_salary_event
  has_one :fare_event
  has_one :tax_event
  has_one :equipment_event
  has_one :other_expense_event
end
