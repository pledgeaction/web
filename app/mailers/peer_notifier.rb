include SendGrid
class PeerNotifier < ApplicationMailer
  def send_email_to_peers(user)
    puts "send_peer_email"
    mail( :to => 'alec.lee15@gmail.com',
          :cc => ['alec.lee@justin.tv', 'alec.lee15@gmail.com'],
          :subject => "hey peer!"
        )
  end
end
