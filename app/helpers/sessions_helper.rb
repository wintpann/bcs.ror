module SessionsHelper

  def log_in(user)
    session[:user_id]=user.id
  end

  def current_user
    if (user_id=session[:user_id])
      @current_user||=User.find_by(id: user_id)
    elsif (user_id=cookies.signed[:user_id])
      user=User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user=user
      end
    end
  end

  def log_out
    forget current_user
    session.delete(:user_id)
    @current_user=nil
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id]=user.id
    cookies.permanent[:remember_token]=user.remember_token
  end

  def forget(user)
    cookies.signed[:user_id]=nil
    cookies[:remember_token]=nil
  end

  def logged_in?
    !current_user.nil?
  end

  def authenticate_user!
    if !logged_in?
      flash[:danger]='You need to log in first'
      redirect_to login_path
    end
  end

  def current_user?(user)
    current_user == user
  end

  def admin_user!
    if !current_user.admin?
      flash[:danger]="You don't have access to this page"
      redirect_to root_path
    end
  end

  def correct_user!
    return true if current_user.admin?

    user=User.find(params[:id])
    if !current_user?(user)
      flash[:danger]="You don't have access to this page"
      redirect_to root_path
    end
  end

end
