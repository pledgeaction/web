include SendGrid
class ErrorNotifier < ApplicationMailer
  def send_error_email
    puts "send_error_email"
    mail( :to => 'benswa@gmail.com',
          :subject => "You got an error!"
        )
  end
end
