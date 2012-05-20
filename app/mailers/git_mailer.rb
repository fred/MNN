class GitMailer < ActionMailer::Base
  if Rails.env.production?
    self.delivery_method = :smtp
  else
    self.delivery_method = :letter_opener
  end

  def push_received(json_payload)
    unless Rails.env.production?
      @@smtp_settings = {
        domain:    "worldmathaba.com",
        address:   "localhost",
        port:      25
      }
    end
    @json_payload = json_payload
    mail(
      from:     "WorldMathaba <inbox@worldmathaba.net>",
      to:       "inbox@worldmathaba.net",
      subject:  "[GIT] #{@json_payload['repository']['owner']['name']} pushed on #{@json_payload['repository']['name']}"
    )
  end
end
