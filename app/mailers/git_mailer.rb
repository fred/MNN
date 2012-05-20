class GitMailer < ActionMailer::Base
  self.delivery_method = :smtp

  def push_received(json_payload)
    @@smtp_settings = {
      domain:    "worldmathaba.com",
      address:   "localhost",
      port:      25
    }
    @json_payload = json_payload
    mail(
      from:     "WorldMathaba <inbox@worldmathaba.net>",
      to:       "inbox@worldmathaba.net",
      subject:  "[GIT] #{@json_payload['repository']['owner']['name']} pushed on #{@json_payload['repository']['name']}"
    )
  end
end
