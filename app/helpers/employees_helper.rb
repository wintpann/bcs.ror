module EmployeesHelper
  def state(employee)
    employee.working? ? "IS WORKING" : "FREE"
  end
end
