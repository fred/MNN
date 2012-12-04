module LayoutHelper

  def logged_in?
    (current_user or current_admin_user)
  end

  def link_to_google_auth
    link_to("Login with Gmail",
      "https://#{Settings.host}/auth/google_oauth2",
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
    if request.domain
      if lang.match(Item::DEFAULT_LOCALE)
        "#{request.domain}"
      else
        "#{lang}.#{request.domain}"
      end
    else
      Settings.host
    end
  end

  def localized_subdomain(lang)
    if request.domain
      "http://#{lang}.#{request.domain}"
    else
      "http://#{Settings.host}"
    end
  end

  def host_link
    "http://#{Settings.host}"
  end

  def flattr_link
    Settings.flattr_link
  end

  def facebook_link
    Settings.facebook_link
  end

  def twitter_link
    Settings.twitter_link
  end

  def google_plus_link
    Settings.google_plus_link
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
      image_tag("icons/social/new/rss_32b.png", width: 32, height: 32, alt: 'rss'),
      feed_path,
      title: "Multiple RSS Feeds"
    )
  end

  def facebook_medium
    link_to(
      image_tag("icons/social/new/facebook_32b.png", width: 32, height: 32, alt: 'Facebook'),
      facebook_link,
      title: "Facebook"
    )
  end

  def twitter_medium
    link_to(
      image_tag("icons/social/new/twitter_32.png", width: 32, height: 32, alt: 'Twitter'),
      twitter_link,
      title: "Twitter"
    )
  end

  def google_plus_medium
    link_to(
      image_tag("icons/social/google_plus_32.png", width: 32, height: 32, alt: 'Google+'),
      google_plus_link,
      title: "Google+",
      rel: "me"
    )
  end

  def google_plus_new
    link_to(
      image_tag("icons/social/new/gplus_32b.png", width: 32, height: 32, alt: 'Google+', class: "google-plus"),
      google_plus_link,
      title: "Google+",
      rel: "me",
      class: "google-plus"
    )
  end
  
  def flattr_large
    link_to(
      image_tag("flattr-badge-large.png", width: 93, height: 20, alt: "Flattr",),
      flattr_link,
      target: "blank",
      title: "Flattr This Site",
      class: 'flattr-large'
    )
  end
  
  def flattr_medium
    link_to(
      image_tag("flattr-badge-medium.png", width: 32, height: 32, alt: "Flattr"),
      flattr_link,
      target: "blank",
      title: "Flattr This Site",
      class: 'flattr-medium'
    )
  end
  
  def flattr_js
    "<a class='FlattrButton' style='display:none;' rev='flattr;button:compact;' href='#{host_link}'></a>
    <noscript>
      <a href='#{flattr_link}' target='_blank'>
        <img src='/assets/flattr-badge-large.png' alt='Flattr this' title='Flattr this' border='0' />
      </a>
    </noscript>"
  end

  def mobile_css(mobile_class='span6',desktop_class='span8')
    if is_mobile?
      mobile_class
    else
      desktop_class
    end
  end

  def form_class(with_class="")
    if is_mobile?
      str = "form-vertical"
    else
      str = "form-horizontal"
    end
    "#{str} #{with_class}"
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
    if is_handheld?
      link_to str, new_session_url(:user, protocol: 'https'), title: "Login"
    else
      "<a data-toggle='modal' data-target='#modal-login' href='#' >#{str}</a>".html_safe
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
