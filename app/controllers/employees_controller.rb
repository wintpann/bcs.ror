class EmployeesController < ApplicationController
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def index
    @employees=User.find(params[:user_id]).employees
  end

  def delete
  end
end
