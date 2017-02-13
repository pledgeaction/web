include SendGrid
class ErrorNotifier < ApplicationMailer
  def send_error_email
    puts "send_error_email"
    mail( :to => 'alec.lee15@gmail.com',
          :subject => "You got an error!"
        )
  end
end
