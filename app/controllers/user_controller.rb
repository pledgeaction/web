class UserController < ApplicationController
  before_filter :require_user
  def require_user
    @user = User.find_by_url(params[:id])
    if @user.blank?
      #ErrorNotifier.send_error_email.deliver
      PeerNotifier.send_email_to_peers(nil).deliver
      render_404

    end
  end

  def view

  end

end
