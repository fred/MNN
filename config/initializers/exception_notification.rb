require 'exception_notification'
Publication::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[WorldMathaba Error] ",
  :sender_address => %{"notifier" <inbox@worldmathaba.net>},
  :exception_recipients => %w{inbox@worldmathaba.net},
  :ignore_crawlers      => %w{Googlebot bingbot bot spider wget curl Yandex}
