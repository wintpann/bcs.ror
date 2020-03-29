class SessionsController < ApplicationController
  def new
  end

  def create
    @user=User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      flash[:success]="Logged in"
      log_in @user
      remember @user if params[:session][:remember_me]=='1'
      redirect_to root_path
    else
      flash[:alert]="Invalid password/login"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
