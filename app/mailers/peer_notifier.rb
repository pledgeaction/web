include SendGrid
class PeerNotifier < ApplicationMailer
  def send_email_to_peers(user)
    puts "send_email_to_peers"
    if user.nil? || !user[:enable_start_conversations]
      logger.warn "nil user or user declined to start conversations"
      return
    end

    peer_emails = user.peers.select{ |p| p[:kind] == 'email' }.map{ |p| p[:to] }
    @user = user

    if user.hours_pledged == 1
      subject = user.name + " just pledged " + user.hours_pledged.round.to_s \
              + " hour a week towards political action."
    else
      subject = user.name + " just pledged " + user.hours_pledged.round.to_s \
              + " hours a week towards political action."
    end

    mail( :to => user[:email],
          :cc => peer_emails,
          :subject => subject
        )
  end
end
