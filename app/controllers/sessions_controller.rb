class SessionsController < ApplicationController
  def new
  end

  def create
    @user=User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      remember @user if params[:session][:remember_me]=='1'
      redirect_to root_path
    else
      flash.now[:alert]="Неверный логин/пароль"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
