include SendGrid
class ApplicationMailer < ActionMailer::Base
  default from: "danny@pledgeaction.org"
  layout 'mailer'
end
