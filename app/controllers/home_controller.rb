class HomeController < ApplicationController

  def home
  end

  def success
    if params[:email]
      ref_url = User.where(:email => params[:email]).last.url
      redirect_to '/success?ref_user=' + ref_url
      return
    end

    @share_url = request.base_url + '/u/' + params[:ref_user]
  end

end
