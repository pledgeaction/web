include SendGrid
class FollowNotifier < ApplicationMailer
  def send_email_to_follows(user)
    puts "send_email_to_follow_targets"
    if user.nil? || !user[:enable_start_conversations]
        puts "nil user or user declined to start conversations"
        return
    end

    follow_emails = user.follows.select{ |p| p[:kind] == 'email' }.map{ |p| p[:to] }
    @user = user

    if user.hours_pledged == 1
      subject = user.name + " just pledged " + user.hours_pledged.round.to_s \
              + " hour a week towards political action and wants your advice."
    else
      subject = user.name + " just pledged " + user.hours_pledged.round.to_s \
              + " hours a week towards political action and wants your advice"
    end

    mail( :to => user[:email],
          :bcc => follow_emails,
          :subject => subject
        )
  end
end
