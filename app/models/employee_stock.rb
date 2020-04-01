class EmployeeStock < ApplicationRecord
  belongs_to :product
  belongs_to :employee
end
