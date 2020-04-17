module EmployeesHelper
  def state(employee)
    employee.working? ? "РАБОТАЕТ" : "СВОБОДЕН"
  end
end
