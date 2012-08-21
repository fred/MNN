module LayoutHelper

  def link_to_google_auth
    link_to("Login with Gmail",
      "/auth/google",
      class: "zocial google",
      rel: 'nofollow',
      title: "Login with Gmail"
    )
  end

  def link_to_twitter_auth
    link_to("Login with Twitter",
      "/auth/twitter",
      class: "zocial twitter",
      rel: 'nofollow',
      title: "Login with Twitter"
    )
  end

  def link_to_windowslive_auth
    link_to("Login Windows Live",
      "/auth/windowslive",
      class: "zocial windows",
      rel: 'nofollow',
      title: "Login Windows Live"
    )
  end

  def link_to_facebook_auth
    link_to("Login with Facebook",
      "/auth/facebook",
      class: "zocial facebook",
      rel: 'nofollow',
      title: "Login with Facebook"
    )
  end

  def canonical_item_link_tag(item)
    tag(:link,
      rel: 'canonical',
      href: url_for(
        item_path(item,
          only_path: false,
          protocol: 'http',
          host: localized_host(item.language_title_short)
        )
      )
    ).html_safe
  end

  def localized_host(lang)
    if lang.match(Item::DEFAULT_LOCALE)
      "#{request.domain}"
    else
      "#{lang}.#{request.domain}"
    end
  end

  def localized_subdomain(lang)
    "http://#{lang}.#{request.domain}"
  end

  def twitter_link
    "https://twitter.com/worldmathaba"
  end

  def google_plus_link
    "https://plus.google.com/b/114360341024930120596/114360341024930120596/posts"
  end

  def twitter_user_link(str)
    if str.match(/^https?:\/\//)
      link_to "@#{str.split("/").last}", str
    else
      link_to "@#{str.gsub('@','')}", "https://twitter.com/#{str.gsub('@','')}"
    end
  end

  def twitter_username(str)
    if str.match(/^https?:\/\//)
      str.split("/").last
    else
      str.gsub('@','')
    end
  end

  def rss_medium
    link_to(
      image_tag("icons/social/rss_32.png", width: 32, height: 32, alt: 'rss'),
      feed_path,
      title: "Multiple RSS Feeds",
      rel: "rss"
    )
  end

  def twitter_medium
    link_to(
      image_tag("icons/social/twitter_32.png", width: 32, height: 32, alt: 'Twitter'),
      twitter_link,
      title: "Twitter",
      rel: "twitter"
    )
  end

  def google_plus_medium
    link_to(
      image_tag("icons/social/google_plus_32.png", width: 32, height: 32, alt: 'google+'),
      google_plus_link,
      title: "Google+",
      rel: "me"
    )
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

  def form_class
    if is_mobile?
      "form-vertical"
    else
      "form-horizontal"
    end
    
  end

  def li_class_subdomain(str, css_class="active")
    if request.subdomains.first && request.subdomains.first.to_s.match(str)
      css_class
    else
      ""
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

  def youtube_height(item)
    if is_mobile?
      item.youtube_mobile_height
    else
      item.youtube_height
    end
  end

  def youtube_width(item)
    if is_mobile?
      item.youtube_mobile_width
    else
      item.youtube_width
    end
  end

end
