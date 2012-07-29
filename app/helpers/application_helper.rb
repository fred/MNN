module ApplicationHelper

  def account_sidebar?
    controller_name.match(/(sessions|registrations|passwords|unlocks)/)
  end

  def http_protocol
    if Rails.env.production?
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
  
  
  def bool_symbol(bol)
    (bol ? '&#x2714;' : '&#x2717;').html_safe
  end
  
  def bool_word(bol)
    (bol ? 'yes' : 'no')
  end
  
end
