class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :active_user!
  before_action :correct_user!
  def new
    @employee=User.find(params[:user_id]).employees.new
  end

  def create
    @employee=User.find(params[:user_id]).employees.new(employee_params)
    if @employee.save
      flash[:success]='Employee added'
      redirect_to user_employee_path(params[:user_id], @employee.id)
    else
      @errors=@employee.errors.full_messages
      render 'new'
    end
  end

  def edit
    @employee=User.find(params[:user_id]).employees.find(params[:id])
  end

  def update
    @employee=User.find(params[:user_id]).employees.find(params[:id])
    if @employee.update(employee_params)
      flash[:success]='Employee updated'
      redirect_to user_employee_path
    else
      @errors=@employee.errors.full_messages
      render 'edit'
    end
  end

  def show
    @employee=User.find(params[:user_id]).employees.find(params[:id])
  end

  def index
    @active_working_employees=User.find(params[:user_id]).active_working_employees
    @active_free_employees=User.find(params[:user_id]).active_free_employees
  end

  def destroy
    @employee=Employee.find(params[:id])
    if @employee.working?
      flash[:danger]='You cannot delete WORKING employee. Finish its job first'
      redirect_to user_employee_path
    else
      toggle_active(@employee)
      flash[:success] = (@employee.active? ? 'Employee restored' : 'Employee deleted')
      redirect_to user_employees_path
    end
  end

  def inactive
    @inactive_employees=User.find(params[:user_id]).inactive_employees
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :fixed_rate, :interest_rate)
  end
end
