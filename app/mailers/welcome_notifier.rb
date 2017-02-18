include SendGrid
class WelcomeNotifier < ApplicationMailer
  def send_welcome_email(user)
    puts "send_welcome_email"
    if user.nil?
        puts "nil user"
        return
    end

    @user = user

    if user.hours_pledged == 1
      subject = "Thanks for your " + user.hours_pledged.round.to_s \
              + " hour a week pledge towards political action"
    else
      subject = "Thanks for your " + user.hours_pledged.round.to_s \
              + " hours a week pledge towards political action"
    end

    mail( :to => user[:email],
          :subject => subject
        )
  end
end
