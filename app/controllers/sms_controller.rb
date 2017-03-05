class SmsController < ApplicationController
  skip_before_filter :verify_authenticity_token
   #skip_before_filter :authenticate_user!, :only => "reply"

  def checkin
    #TODO write answer of have_organization to database.
    #TODO remind people of people and organizations they thought they would want to work with.
    message_body = params["Body"]
    from_number = params["From"]
    boot_twilio
    @checkin = Checkin.where(phone_number: from_number).last
    @user = User.where(phone_number: from_number).where(enable_text_checkins: true).last

    if message_body == "0"
      @checkin.update(hours: 0)
      if @user.has_working_group == nil or @user.has_working_group == false
        @checkin.update(last_question: "have_working_group")
        render plain: "Happens, I recommend making a plan right now for the next couple weeks.

Have you got at least one friend committed to work with you?"
        return
      else
        @checkin.update(last_question: "have_organization")
        render plain: "Happens, I recommend making a plan right now for the next couple weeks.
Have you found an organization to help? (or started your own)"
        return
      end
    elsif (1 .. 24 * 7).member?(message_body.to_i)
      render plain: "Dope! Keep up the good work."
      @checkin.update(hours: message_body.to_i)
      return
    end

    case message_body.downcase
    when "unsub"
      #TODO verify all the yes's work, the no's work as intended.

      #TODO maybe prompt them to reduce their pledge hours at this point.
      @user.update(enable_text_checkins: false)
      render plain: 'Kk. You\'ve been unsubscribed from these check ins. Text "resub" if you\'d like to resubscribe'

    when "resub"
      @user = User.where(phone_number: from_number).last
      @user.update(enable_text_checkins: true)
      render plain: 'And we\'re back! You\'ve been resubscribed to these check ins. Text "unsub" if you\'d like to unsubscribe'

    when "how"
      if @user.has_working_group == nil or @user.has_working_group == false
        @checkin.update(last_question: "have_working_group")
        render plain: "Have you got at least one friend committed to work with you?"
      else
        @checkin.update(last_question: "have_organization")
        render plain: "Have you found an organization to help? (or started your own)"
      end

    when "yes"
      case @checkin.last_question
      when "have_working_group"
        @user.update(has_working_group: true)
        @checkin.update(last_question: "have_organization")
        render plain: "Amazing. The buddy system is mission critical here.

Have you found an organization to volunteer/work for? (or started your own)"
      when "get_working_group_this_week"
        render plain: "Then focus on that for sure. That'd be huge"
      when "get_working_group_this_month"
        render plain: "Then focus on that for sure. That'd be huge"
      when "have_organization"
        render plain: "That's dope. Your squad is way ahead of the curve."
      when "help_pledge_directly"
        render plain: "Amazing!

Email volunteer@pledgeaction.org and we'll get you sorted"

      when "expect_to_fulfill_next_week"
        render plain: "That's dope!

I'm so glad I could help you form a plan :D"
      end

    when "no"
      case @checkin.last_question
      when "have_working_group"
        @user.update(has_working_group: false)
        @checkin.update(last_question: "get_working_group_this_week")
        render plain: "Can you sort that out this week?"
      when "get_working_group_this_week"
        @checkin.update(last_question: "get_working_group_this_month")
        render plain: "No worries. We all have busy weeks. How about this month? The buddy system really is mission critical here"
      when "get_working_group_this_month"
        @checkin.update(last_question: "have_organization")
        render plain: "Ok lone wolf. Scratch the buddy system for now. Have you found an organization to help? (or started your own)"
      when "have_organization"
        if @user.pledge_material == true
          @checkin.update(last_question: "help_pledge_directly")
          render plain: "It looks like you've got some skillz. How about helping The Pledge directly?"
        else
          @checkin.update(last_question: "expect_to_fulfill_next_week")
          render plain: "We particularly like brandnewcongress.org
You should definitely check them out.

We'll keep adding more recommendations as time goes on. If you're not looking to link up with anyone else calling your representatives every week is a safe bet:
thesixtyfive.org/home

I hope that's helpful. Do you expect to be able to fulfill your pledge next week?"
        end

      when "help_pledge_directly"
        @checkin.update(last_question: "expect_to_fulfill_next_week")
        render plain: "We also particularly like brandnewcongress.org
You should definitely check them out.

We'll keep adding more recommendations as time goes on. If you're not looking to link up with anyone else calling your representatives every week is a safe bet:
thesixtyfive.org/home

I hope that's helpful. Do you expect to be able to fulfill your pledge next week?"

      when "expect_to_fulfill_next_week"
        render plain: "A tricky case. I'm sorry I couldn't be more helpful just now. Send an email to help@pledgeaction.org and we'll do our best"
      end
    else
      render plain: 'I didn\'t quite follow :/
I understand: "how", "yes", "no", "unsub", "resub" and numbers like 0, 1, 2, 3,'
    end
  end

  private

  def boot_twilio
    sid = ENV["TWILIO_SID"]
    secret = ENV["TWILIO_SECRET"]
    @client = Twilio::REST::Client.new sid, secret
  end
end
