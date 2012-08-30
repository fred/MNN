class ApplicationController < ActionController::Base
  include FastGettext::Translation
  include SimpleCaptcha::ControllerHelpers
  require 'uri'
  require 'set'
  
  protect_from_forgery

  before_filter :set_gettext_locale
  before_filter :sidebar_variables
  before_filter :mini_profiler  
  before_filter :get_locale
  before_filter :https_for_admins
  before_filter :set_start_time, :set_time_zone, :set_view_items, :current_ability
  before_filter :log_additional_data, :set_per_page
  before_filter :last_modified
  before_filter :no_cache_for_admin
  before_filter :private_headers
  after_filter  :auto_login_admin_user
  after_filter  :store_location
  after_filter  :log_session


  def sidebar_variables
    @site_categories   ||= Category.order("priority ASC, title DESC")
    @site_pages        ||= Page.order("priority ASC")
    @site_languages    ||= Language.order("locale ASC")
    @site_country_tags ||= CountryTag.order("title ASC")
    @site_general_tags ||= GeneralTag.order("title ASC")
    @site_region_tags  ||= RegionTag.order("title ASC")
    @site_links        ||= Link.order("title ASC")
  end

  def no_cache_for_admin
    if current_user or request[:controller].to_s.match("admin|users|comments|devise")
      private_headers
    end
  end

  def get_locale
    subdomain = extract_locale_from_subdomain
    if subdomain
      extracted_locale = extract_locale_from_subdomain
      I18n.locale = extracted_locale
      FastGettext.locale = extracted_locale
      session[:locale] = extracted_locale
    else
      set_default_locale
    end
    Rails.logger.debug("  Locale: FastGettext=#{FastGettext.locale} I18n=#{I18n.locale.to_s}")
  end

  def redirect_to_default_domain(str)
    if str.match(default_locale)
      new_host = str.gsub("#{default_locale}\.",'')
      redirect_to "#{request.host}#{new_host}"
    end
  end

  # Get locale code from request subdomain (like http://it.application.local:3000)
  # You have to put something like:
  #   127.0.0.1 gr.application.local
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first
    Rails.logger.debug("  Locale: Setting locale from subdomain to '#{parsed_locale}'")
    if parsed_locale && locale_available?(parsed_locale.to_s)
      Rails.logger.debug("  Locale: Setting locale from subdomain to '#{parsed_locale}'")
      parsed_locale
    else
      nil
    end
  end

  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.to_s.split('.').last
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale  : nil
  end

  def default_locale
    'en'
  end

  def set_default_locale
    FastGettext.locale = default_locale
    I18n.locale = default_locale.to_sym
  end

  def locale_provided?
    params[:locale] && locale_available?(params[:locale].to_s)
  end

  def locale_available?(str)
    str.match('(ar|de|en|es|fr|it|nl|pt|ru)')
  end

  def set_locale_from_session
    FastGettext.locale = session[:locale]
    I18n.locale = session[:locale].to_sym
  end

  def set_locale_from_params
    FastGettext.locale = params[:locale]
    I18n.locale = params[:locale].to_sym
    session[:locale] = params[:locale].to_sym
  end

  def https_for_admins
    if Rails.env.production? && current_admin_user && (request.protocol == "http://")
      Rails.logger.info("  *** Redirecting user to HTTPS")
      redirect_to request.url.gsub("http://", "https://")
      # Warning! Need to have this in Nginx https config block
      # proxy_set_header X_FORWARDED_PROTO https;
    end
  end

  def auto_login_admin_user
    if current_admin_user && !current_user
      Rails.logger.info("  Auto sign-in for AdminUser ID##{current_admin_user.id}")
      sign_in(:user, current_admin_user, bypass: true)
    end
  end

  comment_destroy_conditions do |comment|
    comment.owner == current_user
  end

  def caching_for_bot
    if should_cache?
      headers_with_timeout(1800, 'public')
    end
  end

  def headers_with_timeout(timeout, method='public')
    if should_cache?
      Rails.logger.info("  Caching On: #{method}, max-age=#{timeout}")
      headers['Cache-Control'] = "#{method}, max-age=#{timeout}"
      headers['Last-Modified'] = @last_published.httpdate if @last_published
      headers['X-Accel-Expires'] = timeout
    end
  end

  def should_cache?
    if (is_bot? or request.format.to_s.match("(rss|atom|xml)")) && !current_user
      true
    else
      false
    end
  end

  def private_headers
    headers['Cache-Control'] = 'private, no-cache'
  end

  def headers_for_etag(etag=nil)
    headers['Etag'] = etag if etag
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
    redirect_to admin_dashboard_path(protocol: http_protocol), alert: exception.message
  end
  
  def default_per_page
    if Rails.env.production?
      24
    else
      6
    end
  end

  def per_page
    if params[:per_page] && params[:per_page].to_s.match("[0-9]{1,}")
      @per_page = params[:per_page].to_s.to_i
    else
      @per_page = default_per_page
    end
    @per_page
  end
  
  def page
    if params[:page] && params[:page].to_s.match("[0-9]{1,}")
      page = params[:page].to_i
    else
      page = 1
    end
  end
  
  def is_mobile?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(iphone|ipod|nokia|series60|symbian|blackberry|opera mini|mobile|iemobile|android|smartphone)"
    invalid="(tablet|ipad|playbook|xoom)"
    if !s.match(invalid) && s.match(valid)
      Rails.logger.info("  UA: Mobile found: #{s}")
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
      Rails.logger.info("  UA: Tablet found: #{s}")
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
    bot="(bot|spider|wget|curl|YandexBot|googlebot|msnbot)"
    if !s.match(bot) && s.match(valid)
      Rails.logger.debug("  UA: user found: #{s}")
      return true
    else
      Rails.logger.debug("  UA: bot found: #{s}")
      return false
    end
  end

  def is_bot?
    return true if Rails.env.test?
    s = request.env["HTTP_USER_AGENT"].to_s.downcase
    valid="(bot|spider|wget|curl|YandexBot|googlebot|msnbot)"
    if s.match(valid)
      Rails.logger.info("  Bot: #{s}")
      return true
    else
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

  def http_protocol
    if Rails.env.production?
      'https'
    else
      'http'
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
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :admin_user, AdminUser
      admin_dashboard_path(protocol: http_protocol)
    when :user, User
      redirect_location
    else
      super
    end
  end

  def redirect_location
    if current_user && current_user.email.match("please_update_your_email")
      edit_user_registration_path(protocol: http_protocol)
    else
      redirect_url
    end
  end


  ### PRIVATE METHODS ###
  protected

  def can_debug?
    # Rails.env.development? && !request[:controller].to_s.match("admin")
    false
  end

  def mini_profiler
    if can_debug?
      Rack::MiniProfiler.authorize_request
    end
  end

    def redirect_url
      if request.env['omniauth.origin']
        request.env['omniauth.origin']
      elsif session[:return_to].present? && session[:return_to].match("items")
        session[:return_to]
      else
        root_path
      end
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_stored_location
      session[:return_to] = nil
    end

    def log_session
      Rails.logger.debug("  Session: #{session.inspect}") if Rails.env.development?
    end

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
