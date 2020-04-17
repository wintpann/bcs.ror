class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :index, :destroy, :show]
  before_action :active_user!, except: [:new, :create]
  before_action :correct_user!, only: [:edit, :update, :show, :destroy]
  before_action :admin_user!, only: :index
  def new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      flash[:success]='Пользователь создан'
      log_in @user
      remember @user
      redirect_to root_path
    else
      @errors=@user.errors.full_messages
      render 'new'
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      flash[:success]='Пользователь обновлен'
      redirect_to root_path
    else
      @errors=@user.errors.full_messages
      render 'edit'
    end
  end

  def show
    @user=User.find(params[:id])
  end

  def index
    @users=User.all_without_admins
  end

  def destroy
    user=User.find(params[:id])
    user.destroy_user
    flash[:success]='Профиль удален'
    log_out if !current_user.admin?
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
