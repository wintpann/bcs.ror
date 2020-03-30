class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!
  def new
  end

  def create
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
    @employees=User.find(params[:user_id]).employees
  end

  def delete
  end

  private

  def employee_params
    params.require(:employee).permit(:name, :fixed_rate, :interest_rate)
  end
end
