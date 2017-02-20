desc "This task is called by the Heroku scheduler add-on"

# task :send_checkins => :environment do
task :send_checkins => do
  puts "sending check_in..."
  sid = ENV["TWILIO_SID"]
  secret = ENV["TWILIO_SECRET"]
  @client = Twilio::REST::Client.new sid, secret
  puts "twilio booted"

  #TODO move from a script to a working rake
  # User.where.not(:phone_number => nil).where.not(:enable_text_checkins => false).find_each do |user|
  #   puts user.phone_number
  # end

  # def send_checkin(phone_number)
  #   text = @client.messages.create(
  #   from: ENV["TWILIO_NUMBER"],
  #   to: from_number,
  #   body: "Hello there, thanks for texting me. Your number is #{from_number}."
  # )
  # end
  #
  # puts "done."
end
