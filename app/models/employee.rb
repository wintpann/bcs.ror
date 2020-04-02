class Employee < ApplicationRecord
  before_save :before_saving

  def before_saving
    self.name.strip!
    self.name.capitalize!
  end

  belongs_to :user
  has_many :employee_stocks
  has_many :giving_events
  has_many :taking_events
  has_many :start_work_session_events

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :fixed_rate, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :interest_rate, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 100 }

  class << self

    def active
      self.all.where(active: true)
    end

    def inactive
      self.all.where(active: false)
    end

    def active_working
      self.active.where(working: true)
    end

    def active_free
      self.active.where(working: false)
    end

  end

  def start_work_session
    self.update_attribute(:working, true)
  end

  def end_work_session
    self.update_attribute(:working, false)
  end

end
