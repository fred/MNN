class ApplicationController < ActionController::Base
  protect_from_forgery
  
  
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
