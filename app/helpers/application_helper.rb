module ApplicationHelper

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
  
  def is_mobile?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(iphone|ipod|nokia|series60|symbian|blackberry|opera mini|mobile|phone|android|smartphone)"
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
