class Product < ApplicationRecord
  before_save :before_saving

  def before_saving
    self.name.strip!
    self.name.upcase!
  end

  belongs_to :user
  has_one :warehouse
  has_many :shopping_events
  has_many :throwing_events
  has_many :giving_events
  has_many :employee_stocks

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :price_in, numericality: { only_integer: true, greater_than: 0 }
  validates :price_out, numericality: { only_integer: true, greater_than: 0 }

  def self.active
    self.all.where(active: true)
  end

  def self.inactive
    self.all.where(active: false)
  end

end
