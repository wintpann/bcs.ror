class ActionsController < ApplicationController
  def warehouse
    @warehouses=User.find(params[:user_id]).warehouses
  end
end
