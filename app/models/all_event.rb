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

  def create_fare(options={})
    if options[:description].empty?
      fare_event=self.create_fare_event(sum: options[:sum])
    else
      fare_event=self.create_fare_event(sum: options[:sum], description: options[:description])
    end
    self.update_attribute(:sum, fare_event.sum)
  end

  def create_tax(options={})
    if options[:description].empty?
      tax_event=self.create_tax_event(sum: options[:sum])
    else
      tax_event=self.create_tax_event(sum: options[:sum], description: options[:description])
    end
    self.update_attribute(:sum, tax_event.sum)
  end

  def create_equipment(options={})
    if options[:description].empty?
      equipment_event=self.create_equipment_event(sum: options[:sum])
    else
      equipment_event=self.create_equipment_event(sum: options[:sum], description: options[:description])
    end
    self.update_attribute(:sum, equipment_event.sum)
  end

  def create_other_expense(options={})
    other_expense_event=self.create_other_expense_event(sum: options[:sum], description: options[:description])
    self.update_attribute(:sum, other_expense_event.sum)
  end

end
