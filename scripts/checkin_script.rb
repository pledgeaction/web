#run in rails

sid = ENV["TWILIO_SID"]
secret = ENV["TWILIO_SECRET"]
@client = Twilio::REST::Client.new sid, secret

User.where.not(:phone_number => nil).where.not(:enable_text_checkins => false).find_each do |user|
  puts user.name
  puts user.phone_number
  Checkin.create(:phone_number => user.phone_number)
  phone_number = user.phone_number

  if user.hours_pledged > 1
    text = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: user.phone_number,
      body: "Hey!

This is Danny checking in on your pledge (#{user.hours_pledged.round.to_s} hours per week).
How many hours did you spend on political action last week?

REPLY with a
number 0, 5, 20, etc
UNSUB to unsubscribe
    "
    )
  else
    text = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: user.phone_number,
      body: "Hey!

This is Danny checking in on your pledge (#{user.hours_pledged.round.to_s} hour per week).
How many hours did you spend on political action last week?

REPLY with a
number 0, 5, 20, etc
UNSUB to unsubscribe
    "
    )
  end

end


# Checkin.create(:phone_number => phone_number)
