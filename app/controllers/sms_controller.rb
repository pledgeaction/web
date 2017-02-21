class SmsController < ApplicationController
  skip_before_filter :verify_authenticity_token
   #skip_before_filter :authenticate_user!, :only => "reply"

  def check_in
    message_body = params["Body"]
    from_number = params["From"]
    puts from_number
    boot_twilio

    if (1 .. 24 * 7).member?(message_body)
      text = @client.messages.create(
        from: ENV["TWILIO_NUMBER"],
        to: from_number,
        body: "Dope, keep up the good work!"
      )
    elsif message_body == "unsub"
      @user = User.where("phone_number = ?", phone_number )[-1]
      @user.enable_text_checkins = false
      @user.save!
      text = @client.messages.create(
        from: ENV["TWILIO_NUMBER"],
        to: from_number,
        body: "Kk. You've been unsubscribed from these alerts."
      )
    else
      text = @client.messages.create(
        from: ENV["TWILIO_NUMBER"],
        to: from_number,
        body: "I didn't quite follow that. I only understand numbers ('1','2','3', etc) and 'unsub'"
      )
    end

  end

  private

  def boot_twilio
    sid = ENV["TWILIO_SID"]
    secret = ENV["TWILIO_SECRET"]
    @client = Twilio::REST::Client.new sid, secret
    puts "twilio booted"
  end
end
