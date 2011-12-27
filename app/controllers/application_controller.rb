class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_time_zone
  
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
