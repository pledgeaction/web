class UserController < ApplicationController
  before_filter :require_user
  def require_user
    puts "require user called"
    @user = User.find_by_url(params[:id])

    if @user.blank?
      ErrorNotifier.send_error_email.deliver
      render_404

    end
  end

  def view

  end

end
