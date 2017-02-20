class SmsController < ApplicationController
  skip_before_filter :verify_authenticity_token
   #skip_before_filter :authenticate_user!, :only => "reply"

  def check_in
    message_body = params["Body"]
    from_number = params["From"]
    puts from_number
    boot_twilio
    text = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: from_number,
      body: "Hello there, thanks for texting me. Your number is #{from_number}."
    )

  end

  private

  def boot_twilio
    sid = ENV["TWILIO_SID"]
    secret = ENV["TWILIO_SECRET"]
    @client = Twilio::REST::Client.new sid, secret
    puts "twilio booted"
  end
end
