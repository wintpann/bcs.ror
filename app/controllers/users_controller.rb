class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :index, :destroy]
  before_action :correct_user!, only: [:edit, :update, :show, :destroy]
  before_action :admin_user!, only: :index
  def new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      flash[:success]='User created'
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
      flash[:success]='User updated'
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
    @users=User.all
  end

  def destroy
    User.destroy(params[:id])
    flash[:success]='Profile deleted'
    log_out if !current_user.admin?
    redirect_to root_path
  end


  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
