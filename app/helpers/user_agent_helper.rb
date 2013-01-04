module UserAgentHelper

  def bot_regex
    "(bot|spider|wget|curl|lwp|perl|crawl|agent|yandex|google|jeeves|metauri|scribdreader|js-kit|rebelmouse|inagist|butterfly)"
  end
  def human_regex
    "(firefox|chrome|opera|safari|webkit|gecko|konqueror|msie|windows|ubuntu|blackberry|iphone|ipad|nokia|android|webos)"
  end
  def mobile_regex
    "(iphone|ipod|nokia|series60|symbian|blackberry|opera mini|mobile|iemobile|android|smartphone)"
  end
  def old_mobile_regex
    "(iphone os [3-4]_|ipad 1|ios [2-4]|ipod|nokia|series60|symbian|blackberry|opera mini|palm)"
  end
  def tablet_regex
    "(tablet|ipad|galaxytab|honeycomb|p1000|playbook|xoom|android|sch-i800|kindle)"
  end
  def touch_regex
    "(ipad|iphone|ipod|android|maemo|honeycomb|galaxytab)"
  end

  def is_touch?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    s.match(touch_regex)
  end

  def is_mobile?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    invalid="(tablet|ipad|playbook|xoom)"
    if !s.match(invalid) && s.match(mobile_regex)
      tagged_logger("UA", "Mobile found: #{s}", :info)
      return true
    else
      return false
    end
  end

  def is_tablet?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    invalid="(mobile|iphone|ipod)"
    if !s.match(invalid) && s.match(tablet_regex)
      tagged_logger("UA", "Tablet: #{s}", :info)
      return true
    else
      return false
    end
  end

  def is_old_mobile?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    if s.match(old_mobile_regex)
      tagged_logger("UA", "Low End Mobile: #{s}", :info)
      return true
    else
      return false
    end
  end
  
  def is_handheld?
    is_mobile? or is_tablet?
  end

  # this should give 99% of users
  def is_human?
    return true if Rails.env.test?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    if !s.match(bot_regex) && s.match(human_regex)
      tagged_logger("UA", "Human: #{s}", :info)
      return true
    else
      tagged_logger("UA", "Bot: #{s}", :info)
      return false
    end
  end

  def is_bot?
    return false if Rails.env.test?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    if s.match(bot_regex)
      tagged_logger("UA", "Bot: #{s}", :info)
      return true
    else
      tagged_logger("UA", "Human: #{s}", :info)
      return false
    end
  end
  
  # This method uses the useragentstring API, 
  # TODO, use this on a QUEUE worker
  def api_is_human?
    uas = request.env["HTTP_USER_AGENT"].to_s
    site = "http://www.useragentstring.com/?uas=#{uas}&getJSON=all"
    uri = URI.escape(site)

    begin
      Timeout::timeout(5) do
        json = JSON.parse Net::HTTP.get(URI(uri))
      end
    rescue Timeout::Error
      tagged_logger("UA", "useragentstring.com Timed out")
      return false
    end

    if json && json["agent_type"].to_s.match("Browser")
      tagged_logger("UA", "User found: #{uas}")
      return true
    else
      tagged_logger("UA", "Bot found: #{uas}")
      return false
    end
  end

end