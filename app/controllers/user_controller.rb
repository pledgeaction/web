class UserController < ApplicationController

  before_filter :require_user
  def require_user
    @user = User.find_by_id(params[:id])
    if @user.blank?
      render_404
    end
  end

  def view

  end



end