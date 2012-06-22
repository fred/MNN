module ApplicationHelper

  def account_sidebar?
    controller_name.match(/(sessions|registrations|passwords|unlocks)/)
  end

  def http_protocol
    if Rails.env.production? && controller_name.match(/(sessions|registrations|passwords|unlocks)/)
      'https'
    else
      'http'
    end
  end


  # Cache for a period of time, default 1 hours
  def cache_expiring(cache_key, cache_period=3600)
    cache([cache_key, Time.now.to_i / cache_period].join('/')){ yield }
  end

  def full_image_path_helper(img)
    root_url.chomp('/') + asset_path(img)
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
  
  
  def bool_symbol(bol)
    (bol ? '&#x2714;' : '&#x2717;').html_safe
  end
  
  def bool_word(bol)
    (bol ? 'yes' : 'no')
  end
  
end
