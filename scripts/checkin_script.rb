#run in rails

sid = ENV["TWILIO_SID"]
secret = ENV["TWILIO_SECRET"]
@client = Twilio::REST::Client.new sid, secret

def checkin_user(user)
  puts user.name
  puts user.phone_number
  Checkin.create(:phone_number => user.phone_number)
  phone_number = user.phone_number

  begin
    if @user.has_working_group == nil or @user.has_working_group == false
      @checkin.update(last_question: "have_working_group")

  "We strongly believe in the buddy system. Have you got at least one friend committed to work with you?"

    elsif @user.has_organization == nil or @user.has_organization == false
      @checkin.update(last_question: "have_organization")
    "Have you found an organization to help? (or started your own)"

    else
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
UNSUB to unsubscribe
"
        )
      end
    end
  rescue Exception => e
    if e.code == 21211
      puts "failed text message, probably an invalid number"
    else
      raise e
    end
  end
end

# Test user
# checkin_user(User.find(id=504)) invalid number
checkin_user(User.find(id=515))

# User.where.not(:phone_number => nil).where.not(:enable_text_checkins => false).find_each do |user|
#   puts ""
#   puts user.name
#   puts user.phone_number
#
# # in case job failed half way through
#   # if ["+13166193650", "+18472198157", "+14846865329", "+18083521086"].include? user.phone_number
#   #   puts "skipping"
#   #   next
#   # end x
#   puts "texting"
#
#   #UNCOMMENT TO ACTUALLY RUN
#   # checkin_user(user)
#
#   @checkin = Checkin.where(phone_number: user.phone_number).last
#   if @checkin
#     puts @checkin.created_at
#     puts @checkin.hours
#     puts @checkin.last_question
#   end
# end
