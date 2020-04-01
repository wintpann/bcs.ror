class Employee < ApplicationRecord
  before_save :before_saving

  def before_saving
    self.name.strip!
    self.name.capitalize!
  end

  belongs_to :user
  has_many :employee_stocks

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :fixed_rate, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :interest_rate, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 100 }

  def self.active
    self.all.where(active: true)
  end

  def self.inactive
    self.all.where(active: false)
  end

  def self.active_working
    self.active.where(working: true)
  end

  def self.active_free
    self.active.where(working: false)
  end

end
