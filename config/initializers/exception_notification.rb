Rails.application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[MNN_Error] ",
  :sender_address => %{"notifier" <inbox@worldmathaba.net>},
  :exception_recipients => %w{inbox@worldmathaba.net worldmathaba@gmail.com}
  
class ExceptionNotifier < ActionMailer::Base
  self.delivery_method = :sendmail
end