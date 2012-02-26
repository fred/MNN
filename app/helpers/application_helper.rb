module ApplicationHelper
  
  def is_mobile?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(iphone|ipod|nokia|series60|symbian|blackberry|opera mini|mobile|iemobile|android|smartphone)"
    invalid="(tablet|ipad|playbook|xoom)"
    if !s.match(invalid) && s.match(valid)
      Rails.logger.debug("  UA: Mobile found: #{s}")
      return true
    else
      return false
    end
  end
  
  def is_tablet?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(tablet|ipad|galaxytab|opera mini|honeycomb|p1000|playbook|xoom|android|sch-i800|kindle)"
    invalid="(mobile|iphone|ipod)"
    if !s.match(invalid) && s.match(valid)
      Rails.logger.debug("  UA: Tablet found: #{s}")
      return true
    else
      return false
    end
  end
  
  def bol_to_word(bol)
    if bol
      "yes"
    else
      "no"
    end
  end
  
end
