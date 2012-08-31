module ApplicationHelper
  include FastGettext::Translation

  def bootstap_flash
     flash_messages = []
     flash.each do |type, message|
     type = :success if type == :notice
     type = :error   if type == :alert
     text = content_tag(:div, link_to("x", "#", class: "close", data:{dismiss: "alert"}) + message, :class => "alert fade in alert-#{type}")
     flash_messages << text if message
    end
    flash_messages.join("\n").html_safe
  end

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


  # Cache for a period of time, default 2 hours
  def cache_expiring(cache_key, cache_period=7200)
    cache(["#{I18n.locale.to_s}/#{cache_key}", Time.now.to_i / cache_period].join('/')){ yield }
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
