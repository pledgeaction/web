#run in rails

User.where.not(:phone_number => nil).where.not(:enable_text_checkins => false).find_each do |user|
  puts user.id, user.phone_number, user.name
end


private

def boot_twilio
  sid = ENV["TWILIO_SID"]
  secret = ENV["TWILIO_SECRET"]
  @client = Twilio::REST::Client.new sid, secret
end

# Checkin.create(:phone_number => phone_number)
