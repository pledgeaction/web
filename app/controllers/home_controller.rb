class HomeController < ApplicationController

  def home
  end

  def success
    if params[:email]
      # look for recently created user and get their referral code
      ref_url = User.where(:email => params[:email]).last.try(:url)
      if ref_url
        redirect_to '/success?ref_user=' + ref_url
        return
      end

      try_count = params[:try].try(:to_i) || 0

      # loop this endpoint until the new user exists in the DB
      if try_count < 4
        sleep(0.2)

        redirect_to '/success?email=' + params[:email] + '&try=' + (try_count + 1).to_s
        return
      else
        render_404
        return
      end
    end

    @share_url = request.base_url + '/u/' + params[:ref_user]
  end

end
