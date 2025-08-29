class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAIL_FROM'] || 'TuneBox <syoutiroukun@gmail.com>'
  layout "mailer"
end
