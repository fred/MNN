module LayoutHelper

  def form_class
    if is_mobile?
      "form-vertical"
    else
      "form-horizontal"
    end
  end


  def li_class(str, sym="id", css_class="active")
    if params[sym.to_sym].present? && (params[sym.to_sym].to_s == str.to_s)
      css_class
    else
      ""
    end
  end

  def login_link(str)
    if is_mobile?
      link_to str, new_session_url(:user, protocol: 'https'), title: "Login"
    else
      "<a data-toggle='modal' data-target='#modal-login' href='#' >#{str}</a>".html_safe
    end
  end

  def is_handheld?
    is_mobile? or is_tablet?
  end

  def is_limitted?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(iphone|ipod|nokia|series60|symbian|blackberry|opera mini)"
    if s.match(valid)
      Rails.logger.debug("  UA: Limitted Mobile found: #{s}")
      return true
    else
      return false
    end
  end
  
  def is_mobile?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(iphone|ipod|nokia|series60|symbian|blackberry|opera mini|mobile|phone|android|smartphone)"
    invalid="(tablet|ipad|playbook|xoom)"
    if s.match(valid) && !s.match(invalid)
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
    if s.match(valid) && !s.match(invalid)
      Rails.logger.debug("  UA: Tablet found: #{s}")
      return true
    else
      return false
    end
  end


end
