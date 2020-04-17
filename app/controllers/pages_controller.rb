class PagesController < ApplicationController
  def home
    if logged_in?
      if current_user.active?
        redirect_to user_path(current_user.id)
      else
        render 'inactive'
      end
    else
      render 'sign'
    end
  end
end
