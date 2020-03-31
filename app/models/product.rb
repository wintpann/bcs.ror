class Product < ApplicationRecord
  before_save :before_saving

  def before_saving
    self.name.strip!
    self.name.upcase!
  end

  belongs_to :user
  has_many :warehouses

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
