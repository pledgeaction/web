#run in rails

sid = ENV["TWILIO_SID"]
secret = ENV["TWILIO_SECRET"]
@client = Twilio::REST::Client.new sid, secret

def checkin_user(user)
  puts user.name
  puts user.phone_number
  Checkin.create(:phone_number => user.phone_number)
  phone_number = user.phone_number

  if user.hours_pledged > 1
    half = user.hours_pledged / 2
    double = user.hours_pledged * 2
    text = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: user.phone_number,
      body: "Hey there!

This is Danny checking in on your pledge (#{user.hours_pledged.round.to_s} hours per week).
How many hours did you spend on political action last week?

REPLY with a
number 0, #{half.round.to_s}, #{user.hours_pledged.round.to_s}, #{double.round.to_s}, etc
HOW to get help making a high impact plan for the week
UNSUB to unsubscribe
"
    )
  else
    text = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: user.phone_number,
      body: "Hey there!

This is Danny checking in on your pledge (#{user.hours_pledged.round.to_s} hour per week).
How many hours did you spend on political action last week?

REPLY with a
number 0, 1, 2, 3 etc
HOW to get help making a high impact plan for the week
UNSUB to unsubscribe
"
    )
  end
end

# Test user
# checkin_user(User.find(id=515))

User.where.not(:phone_number => nil).where.not(:enable_text_checkins => false).find_each do |user|
  puts user.name
  puts user.phone_number
  @checkin = Checkin.where(phone_number: user.phone_number).last
  puts @checkin.hours
  puts @checkin.last_question
  # checkin_user(user)
end
