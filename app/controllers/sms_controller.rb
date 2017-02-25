class SmsController < ApplicationController
  skip_before_filter :verify_authenticity_token
   #skip_before_filter :authenticate_user!, :only => "reply"

  def checkin
    message_body = params["Body"]
    from_number = params["From"]
    boot_twilio

    if message_body == "0"
      #TODO look up their pledge amount, give them a friendly reminder of that.
      render plain: "Happens, I recommend making a plan right now for the next couple weeks"
      @checkin = Checkin.where(phone_number: from_number).last
      @checkin.update(hours: 0)
    elsif (1 .. 24 * 7).member?(message_body.to_i)
      render plain: "Dope! Keep up the good work."
      @checkin = Checkin.where(phone_number: from_number).last
      @checkin.update(hours: message_body.to_i)
    elsif message_body.downcase == "unsub"
      #TODO maybe prompt them to reduce their pledge hours at this point.
      @user = User.where(phone_number: from_number).where(enable_text_checkins: true).last
      @user.update(enable_text_checkins: false)
      render plain: 'Kk. You\'ve been unsubscribed from these check ins. Text "resub" if you\'d like to resubscribe'
    elsif message_body.downcase == "resub"
      @user = User.where(phone_number: from_number).where(enable_text_checkins: false).last
      @user.update(enable_text_checkins: true)
      render plain: 'And we\'re back! You\'ve been resubscribed to these check ins. Text "unsub" if you\'d like to unsubscribe'
    else
      render plain: 'I didn\'t quite follow :/
I only understand numbers like 0, 1, 2, 3, "unsub", and "resub"'
    end
  end

  private

  def boot_twilio
    sid = ENV["TWILIO_SID"]
    secret = ENV["TWILIO_SECRET"]
    @client = Twilio::REST::Client.new sid, secret
  end
end
