class UsersController < ApplicationController
  def new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      flash[:success]='User created'
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


  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
