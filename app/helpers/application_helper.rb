module ApplicationHelper
  include FastGettext::Translation

  def fragment_cache_time
    Settings.fragment_cache_time || 3600
  end

  def tagged_logger(tag,msg,level=:debug)
    if level == :info
      Rails.logger.tagged(tag) { Rails.logger.info(msg) }
    elsif level == :warn
      Rails.logger.tagged(tag) { Rails.logger.warn(msg) }
    else
      Rails.logger.tagged(tag) { Rails.logger.debug(msg) }
    end
  end

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

  def comment_cache_key(comment)
    if current_user
      "user-#{current_user.id}/#{comment.cache_key}"
    elsif current_admin_user
      "user-#{current_admin_user.id}/#{comment.cache_key}"
    else
      comment.cache_key
    end
  end


  def sidebar_cache_key
    p = []
    p << "category-#{@category.id}" if @category
    p << "page-#{@page.id}" if @page
    "sidebar/#{p.join('-')}"
  end

  def cache_key_for_user(str='')
    if current_admin_user
      "admin_user/#{current_admin_user.id}/#{str}"
    elsif current_user
      "user/#{current_user.id}/#{str}"
    else
      "guest/#{str}"
    end
  end

  # Cache for a period of time, default 16 hours
  def cache_expiring(cache_key, cache_period = 16.hours, no_cache = false)
    if no_cache
      tagged_logger("CACHE", "Not caching for current_user")
      yield
    else
      key = ["#{I18n.locale.to_s}/#{cache_key}", Time.now.to_i / cache_period].join('/')
      tagged_logger("CACHE", "Key: #{key}")
      cache(key){ yield }
    end
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
