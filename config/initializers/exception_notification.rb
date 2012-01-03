Rails.application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[MNN_Rails_Error] ",
  :sender_address => %{"notifier" <fred.the.master@gmail.com>},
  :exception_recipients => %w{fred.the.master@gmail.com}