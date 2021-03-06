class FareEvent < ApplicationRecord
  belongs_to :all_event

  validates :sum, numericality: { only_integer: true, greater_than: 0 }
  validates :description, length: {maximum: 250}
end
