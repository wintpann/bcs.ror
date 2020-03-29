class UsersController < ApplicationController
  def new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      flash[:success]='Пользователь создан!'
      #redirect_to root_path
    else
      @errors=@user.errors.full_messages
      render 'new'
    end
  end


  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
