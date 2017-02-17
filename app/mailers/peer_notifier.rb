include SendGrid
class PeerNotifier < ApplicationMailer
  def send_email_to_peers(user)
    puts "send_email_to_peers"
    if user.nil? || !user[:enable_start_conversations]
        puts "nil user or user declined to start conversations"
        return
    end

    peer_emails = user.peers.select{ |p| p[:kind] == 'email' }.map{ |p| p[:to] }
    @user = user
    subject = user.name + " just pledged " + @user.hours_pledged.round.to_s \
              + " a week towards political action."

    mail( :to => user[:email],
          :cc => peer_emails,
          :subject => subject
        )
  end
end
