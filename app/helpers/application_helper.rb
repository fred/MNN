module ApplicationHelper
  
  def is_mobile?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(iphone|nokia|blackberry|opera mini|iemobile)"
    invalid="(tablet|ipad)"
    if !s.match(invalid) && s.match(valid)
      Rails.logger.debug("  UA: mobile found: #{s}")
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
