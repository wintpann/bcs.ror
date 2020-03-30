module EmployeesHelper
  def working?(employee)
    employee.working? ? "IS WORKING" : "FREE"
  end
end
