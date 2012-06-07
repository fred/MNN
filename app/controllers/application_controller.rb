class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  require 'uri'
  require 'set'
  
  protect_from_forgery
  
  before_filter :set_start_time, :set_time_zone, :set_view_items, :current_ability
  before_filter :log_additional_data, :set_per_page
  before_filter :last_modified
  
  
  comment_destroy_conditions do |comment|
    comment.owner == current_user
  end

  def headers_with_timeout(timeout,method='public')
    headers['Cache-Control'] = "#{method}, max-age=#{timeout}" unless (current_admin_user or current_user)
    headers['Last-Modified'] = @last_published.httpdate if @last_published
  end

  def private_headers
    headers['Cache-Control'] = 'private, no-cache'
  end

  def last_modified
    @last_item = Item.last_item
    if @last_item && @last_modified.nil?
      @last_modified = @last_item.updated_at.httpdate
    else
      @last_modified = Time.now.httpdate
    end
  end
  
  def set_per_page
    if params[:per_page]
      @per_page = params[:per_page].to_i
    end
  end
  
  def set_start_time
    @start_time = Time.now.usec
  end

  def current_ability
    if current_admin_user
      @current_ability ||= Ability.new(current_admin_user) 
    else
      @current_ability ||= Ability.new(User.new) 
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, alert: exception.message
  end
  
  
  def per_page
    if params[:per_page]
      @per_page = params[:per_page]
    else
      @per_page = 24
    end
    @per_page
  end
  
  
  def is_mobile?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(iphone|ipod|nokia|series60|symbian|blackberry|opera mini|mobile|iemobile|android|smartphone)"
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
  
  # this should give 99% of users
  def is_human?
    return true if Rails.env.test?
    
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
  
  # This method uses the useragentstring API, 
  # TODO, use this on a QUEUE worker
  def api_is_human?
    uas = request.env["HTTP_USER_AGENT"].to_s
    site = "http://www.useragentstring.com/?uas=#{uas}&getJSON=all"
    uri = URI.escape(site)

    begin
      Timeout::timeout(2) do
        json = JSON.parse Net::HTTP.get(URI(uri))
      end
    rescue Timeout::Error
      Rails.logger.debug("  UA: useragentstring.com Timed out")
      return false
    end
    
    res = json["agent_type"].to_s.match("(Browser|Feed)")
    if res
      Rails.logger.debug("  UA: user found: #{uas}")
      return true
    else
      Rails.logger.debug("  UA: bot found: #{uas}")
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
      Rails.logger.debug("  Timezone: #{current_user.time_zone}")
      Time.zone = current_user.time_zone
    elsif current_admin_user && current_admin_user.time_zone
      Rails.logger.debug("  Timezone: #{current_admin_user.time_zone}")
      Time.zone = current_admin_user.time_zone
    end
  end
  
  # temporarily use mobile by setting by URL
  def get_layout
    if params[:mobile_mode] or session[:mobile_mode] == "1"
      session[:mobile_mode] = "1"
      layout_name = "mobile"
    elsif params[:desktop_mode]
      session[:mobile_mode] = nil
      layout_name = "items"
    else
      layout_name = "items"
    end
    return "items"
  end


  def opensearch
    response.headers['Content-Type'] = 'application/opensearchdescription+xml; charset=utf-8'
  end

  # Customize the Devise after_sign_in_path_for() for redirecct to previous page after login
  def after_sign_in_path_for(resource)
    case resource
    when :user, User
      store_location = session[:user_return_to]
      if store_location.nil?
        root_path
      else
        store_location.to_s
      end
    else
      super
    end
  end

  protected

    def log_additional_data
      request.env["exception_notifier.exception_data"] = {
        current_user: current_user
      } if current_user
      request.env["exception_notifier.exception_data"] = {
        current_admin_user: current_admin_user
      } if current_admin_user
    end

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
