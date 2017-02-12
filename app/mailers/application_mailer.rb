include SendGrid
class ApplicationMailer < ActionMailer::Base
  default from: "foo@bar.com"
  layout 'mailer'
end
