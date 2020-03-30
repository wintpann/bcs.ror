class Product < ApplicationRecord
  before_save{self.name.downcase!}

  belongs_to :user

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :price_in, numericality: { only_integer: true, greater_than: 0 }
  validates :price_out, numericality: { only_integer: true, greater_than: 0 }
end
