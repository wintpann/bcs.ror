class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user!
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
    @employee=User.find(params[:user_id]).employees.find(params[:id])
  end

  def index
    @employees=User.find(params[:user_id]).employees
  end

  def delete
  end
end
