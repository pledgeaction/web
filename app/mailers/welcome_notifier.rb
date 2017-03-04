include SendGrid
class WelcomeNotifier < ApplicationMailer
  def send_welcome_email(user)
    logger.info "send_welcome_email"
    if user.nil?
      logger.warn "nil user"
      return
    end

    if user.hours_pledged.nil?
      logger.warn "No hours for user: #{user.id}"
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
