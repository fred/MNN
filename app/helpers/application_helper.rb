module ApplicationHelper



  def login_link(str)
    if is_limitted?
      link_to str, new_session_url(:user, protocol: 'https'), title: "Login"
    else
      "<a data-toggle='modal' data-target='#modal-login' href='#' >#{str}</a>".html_safe
    end
  end

  # Cache for a period of time, default 2 hours
  def cache_expiring(cache_key, cache_period=7200)
    cache([cache_key, Time.now.to_i / cache_period].join('/')){ yield }
  end

  def full_image_path_helper(img)
    root_url.chomp('/') + asset_path(img)
  end
  
  def twitter_user_link(str)
    link_to "@#{str}", "https://twitter.com/#{str}"
  end
  
  def flattr_large
    link_to(
      image_tag("flattr-badge-large.png", width: 93, height: 20),
      "http://flattr.com/thing/631126/WorldMathaba",
      target: "blank",
      alt: "Flattr This Site",
      title: "Flattr This Site"
    )
  end
  
  def flattr_medium
    link_to(
      image_tag("flattr-badge-medium.png", width: 32, height: 32),
      "http://flattr.com/thing/631126/WorldMathaba",
      target: "blank",
      alt: "Flattr This Site",
      title: "Flattr This Site"
    )
  end
  
  def flattr_js
    "<a class='FlattrButton' style='display:none;' rev='flattr;button:compact;' href='http://Worldmathaba.net'></a>
    <noscript>
      <a href='http://flattr.com/thing/631126/WorldMathaba' target='_blank'>
        <img src='/assets/flattr-badge-large.png' alt='Flattr this' title='Flattr this' border='0' />
      </a>
    </noscript>"
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
    if s.match(valid)
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
    if s.match(valid)
      Rails.logger.debug("  UA: Tablet found: #{s}")
      return true
    else
      return false
    end
  end
  
  def bool_symbol(bol)
    (bol ? '&#x2714;' : '&#x2717;').html_safe
  end
  
  def bool_word(bol)
    (bol ? 'yes' : 'no')
  end
  
end
