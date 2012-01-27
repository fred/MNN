class ApplicationController < ActionController::Base
  require 'set'
  
  protect_from_forgery
  
  before_filter :set_time_zone, :set_view_items
  
  # this should give 99% of users
  def is_human?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(firefox|chrome|opera|safari|webkit|gecko|msie|windows|blackberry|iphone|ipad|nokia|android|fedora|ubuntu|centos)"
    bot="(bot|spider)"
    if !s.match(bot) && s.match(valid)
      Rails.logger.debug("  UA: user found: #{s}")
      return true
    else
      Rails.logger.debug("  UA: bot found: #{s}")
      return false
    end
  end
  
  
  def set_view_items
    unless session[:view_items]
      session[:view_items] = Set.new
    end
  end
  
  def set_time_zone
    if current_user && current_user.time_zone
      Rails.logger.info("*** Setting timezone for user to #{current_user.time_zone}")
      Time.zone = current_user.time_zone
    end
    if current_admin_user && current_admin_user.time_zone
      Rails.logger.info("*** Setting timezone for user to #{current_admin_user.time_zone}")
      Time.zone = current_admin_user.time_zone
    end
  end
  
  protected

  def user_for_paper_trail
    if admin_user_signed_in?
      current_admin_user
    elsif user_signed_in?
      current_user
    else
      "Unknown user"
    end
  end
  
end
