class User < ActiveRecord::Base
  serialize :oauth_data, Hash

  mount_uploader :avatar, AvatarUploader
  mount_uploader :gpg, GpgUploader

  acts_as_voter
  # The following line is optional, and tracks karma (up votes) for questions this user has submitted.
  # Each question has a submitter_id column that tracks the user who submitted it.
  # The option :weight value will be multiplied to any karma from that voteable model (defaults to 1).
  # You can track any voteable model.
  has_karma(:comments, as: :owner, weight: 0.5)
  has_karma(:items, as: :user, weight: 1)

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :bio, :name, :address,
      :twitter, :diaspora, :skype, :gtalk, :jabber, :avatar, :remove_avatar, :phone_number, :time_zone,
      :role_ids, :roles, :subscribe, :unsubscribe, :unsubscribe_all, :upgrade, :downgrade,
      :terms_of_service, :registration_role, :gpg, :facebook

  attr_accessor :subscribe, :unsubscribe, :unsubscribe_all, :upgrade, :downgrade

  validates_acceptance_of :terms_of_service, accept: '1', on: :create unless Rails.env.test?
  validates_exclusion_of :password, in: lambda { |p| [p.name] }, message: "should not be the same as your name"
  validates :email, email_format: {message: 'is not looking good'}, on: :create

  validate :check_security, on: :create

  # validates_presence_of :password, unless: Proc.new {|user| user.oauth_token.present?}
  # validates_presence_of :password_confirmation, unless: Proc.new {|user| user.oauth_token.present?}

  # Relationships
  has_many :items,  inverse_of: :user
  has_many :scores
  has_many :comments, foreign_key: :owner_id
  has_many :subscriptions, dependent: :destroy, conditions: {item_id: nil}
  has_many :comment_subscriptions, dependent: :destroy
  has_many :page_views
  has_many :search_queries

  has_and_belongs_to_many :roles

  before_save   :create_subscriptions
  before_save   :cancel_subscriptions
  before_save   :update_subscriptions
  before_save   :check_upgrade
  after_create  :notify_admin
  after_create  :send_welcome_email

  apply_simple_captcha

  def full_karma
    score = 0
    score += karma
    score += original_items_karma
    score += comments_karma
    score += items_karma
    score
  end

  def original_items_karma
    (Math.log((original_items_count/100)+1) + Math.log(original_items_count+1) * 4).round
  end

  def items_karma
    (Math.log((items_count/100)+1) + Math.log(items_count+1)*2).round
  end

  def comments_karma
    karma + (Math.log((comments_count/100)+1) + Math.log(comments_count+1)).round
  end

  def comments_trusted?
    comments_karma > 4
  end

  def tiny_mce_buttons2
    if comments_trusted?
      "cut,copy,paste,pastetext,pasteword,selectall,|,bullist,numlist,|,outdent,indent,blockquote,|,link,unlink,anchor,|,image,|,removeformat,cleanup,|,insertdate,inserttime,preview"
    else
      ""
    end
  end

  def check_security
    unless secured?
      Rails.logger.info("  Security breach, user tried priviledge escalation.")
      errors.add(:user, " Are you trying to do something fancy?")
    end
  end

  def secured?
    roles == [] && role_ids == [] && upgrade == nil
  end

  def notify_admin
    if Rails.env.production?
      UserMailer.delay_for(15).new_user(self.id) 
    else
      UserMailer.new_user(self.id).deliver
    end
  end

  # Send welcome email, except for twitter users
  def send_welcome_email
    unless (self.provider.present? && self.provider.match("twitter"))
      if Rails.env.production?
        UserMailer.delay_for(15).welcome_email(self.id)
      else
        UserMailer.welcome_email(self.id).deliver
      end
    end
  end

  def check_upgrade
    if (self.upgrade.to_s == "1" or self.upgrade == true) && !self.is_admin?
      self.type = "AdminUser"
    elsif (self.downgrade.to_s == "1" or self.downgrade == true) && self.is_admin?
      self.type = "User"
    end
    true
  end

  def original_items_count
    items.published.original.count
  end

  def is_admin?
    type == "AdminUser"
  end

  def title
    if name.present?
      name
    else
      email
    end
  end

  def public_display_name
    if name.present?
      name
    else
      "Anonymous ##{id.to_s}"
    end
  end

  def display_name
    if name.present?
      name
    else
      "user-#{id.to_s}"
    end
  end

  def has_image?
    avatar?
  end

  def main_image(version=nil)
    if has_image?
      if version
        avatar.url(version)
      else
        avatar.url
      end
    elsif oauth_data && oauth_data[:info] && oauth_data[:info][:image]
      oauth_data[:info][:image].to_s
    else
      "mini_logo.png"
    end
  end

  def has_role?(role_sym)
    roles.any? { |r| r.title.underscore.to_sym == role_sym }
  end

  def has_any_role?(*roles_array)
    roles_array.each do |t|
      if has_role?(t.to_sym)
        return true
      end
    end
    return false
  end

  def role_titles
    self.roles.collect {|t| t.title}.join(", ")
  end

  def role_models
    rol = []
    self.roles.collect.each do |t|
      rol << t.title.capitalize
    end
    rol
  end

  def has_subscription?
    !self.subscriptions.empty?
  end

  def create_subscriptions
    if (self.subscribe.to_s == "1" or self.subscribe == true) && self.subscriptions.empty?
      self.subscriptions << Subscription.new(email: self.email)
    elsif (self.unsubscribe.to_s == "1" or self.unsubscribe == true) && !self.subscriptions.empty?
      self.subscriptions.destroy_all
    end
    true
  end

  def update_subscriptions
    if self.email_changed? && !self.subscriptions.empty? 
      self.subscriptions.last.update_attributes(email: self.email)
    end
    true
  end

  def cancel_subscriptions
    if (self.unsubscribe_all.to_s == "1" or self.unsubscribe_all == true) && !self.subscriptions.empty?
      self.subscriptions.destroy_all
    end
    true
  end

  def comments_count
    Comment.where(owner_id: id, approved: true, marked_spam: false).count
  end

  def my_items
    items.
    published.
    not_draft.
    includes(:attachments, :user, :tags, :item_stat).
    order("original DESC, published_at DESC")
  end

  def twitter_username
    if twitter.to_s.match(/^https?:\/\//)
      twitter.to_s.split("/").last
    else
      twitter.to_s.gsub('@','')
    end
  end

  def mark_as_confirmed
    self.confirmation_token = nil
    self.confirmed_at = Time.now
  end

  def self.find_or_create_from_oauth(auth_hash)
    case auth_hash.provider
    when 'facebook'
      User.facebook_oauth(auth_hash)
    when 'twitter'
      User.twitter_oauth(auth_hash)
    when 'flattr'
      User.flattr_oauth(auth_hash)
    when 'google_oauth2'
      User.google_oauth(auth_hash)
    when 'windowslive'
      User.windowslive_oauth(auth_hash)
    end
  end

  def self.facebook_oauth(auth_hash)
    # user = where(oauth_uid: auth_hash.uid, provider: 'facebook').first
    user = where("(oauth_uid = ? AND provider = ?) OR email = ?", auth_hash.uid, 'facebook', auth_hash.info.email).first
    unless user
      user = User.new
      user.name = auth_hash.info.name
      user.email = auth_hash.info.email
      user.facebook = auth_hash.info.urls.Facebook
    end
    if auth_hash.extra.raw_info.timezone
      user.time_zone = ActiveSupport::TimeZone[auth_hash.extra.raw_info.timezone.to_i].name
    end
    user.provider = 'facebook'
    user.oauth_uid = auth_hash.uid
    user.oauth_data = auth_hash
    user.oauth_token = auth_hash.credentials.token
    if user.new_record?
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end
    user.mark_as_confirmed
    user.save
    user
  end

  def self.twitter_oauth(auth_hash)
    user = where(oauth_uid: auth_hash.uid, provider: 'twitter').first
    unless user
      user = User.new
      user.name = auth_hash.info.name
      user.email = "please_update_email_#{Kernel.rand(999999)}@worldmathaba.net"
      user.twitter = auth_hash.info.urls.Twitter
    end
    if auth_hash.extra.raw_info.timezone
      user.time_zone = ActiveSupport::TimeZone[auth_hash.extra.raw_info.timezone.to_s].name
    end
    user.provider = 'twitter'
    user.oauth_uid = auth_hash.uid
    user.oauth_data = auth_hash
    user.oauth_token = auth_hash.credentials.token
    if user.new_record?
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end
    user.mark_as_confirmed
    user.save
    user
  end


  def self.flattr_oauth(auth_hash)
    user = where(oauth_uid: auth_hash.uid, provider: 'flattr').first
    unless user
      user = User.new
      user.name = auth_hash.info.name
      user.email = auth_hash.info.email
    end
    if auth_hash.extra.raw_info.timezone
      user.time_zone = ActiveSupport::TimeZone[auth_hash.extra.raw_info.timezone.to_i].name
    end
    user.provider = 'flattr'
    user.oauth_uid = auth_hash.uid
    user.oauth_data = auth_hash
    user.oauth_token = auth_hash.credentials.token
    if user.new_record?
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end
    user.mark_as_confirmed
    user.save
    user
  end

  def self.google_oauth(auth_hash)
    # user = where(oauth_uid: auth_hash.uid, provider: 'google').first
    user = where("(oauth_uid = ? AND provider = ?) OR email = ?", auth_hash.uid, 'google', auth_hash.info.email).first

    unless user
      user = User.new
      user.name = auth_hash.info.name
      user.email = auth_hash.info.email
    end
    if auth_hash.extra.raw_info.timezone
      user.time_zone = ActiveSupport::TimeZone[auth_hash.extra.raw_info.timezone.to_i].name
    end
    user.provider = 'google'
    user.oauth_uid = auth_hash.uid
    user.oauth_data = auth_hash
    user.oauth_token = auth_hash.credentials.token
    if user.new_record?
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end
    user.mark_as_confirmed
    user.save
    user
  end

  def self.linkedin_oauth(auth_hash)
    user = where(oauth_uid: auth_hash.uid, provider: 'linkedin').first
    unless user
      user = User.new
      user.name = auth_hash.info.name
      user.email = "please_update_email_#{Kernel.rand(999999)}@worldmathaba.net"
      user.oauth_page = auth_hash.info.urls.public_profile
    end
    if auth_hash.extra.raw_info.timezone
      user.time_zone = ActiveSupport::TimeZone[auth_hash.extra.raw_info.timezone.to_i].name
    end
    user.provider = 'linkedin'
    user.oauth_uid = auth_hash.uid
    user.oauth_data = auth_hash
    user.oauth_token = auth_hash.credentials.token
    if user.new_record?
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end
    user.mark_as_confirmed
    user.save
    user
  end

  def self.windowslive_oauth(auth_hash)
    # user = where(oauth_uid: auth_hash.uid, provider: 'windowslive').first
    user = where("(oauth_uid = ? AND provider = ?) OR email = ?", auth_hash.uid, 'windowslive', auth_hash.info.email).first
    unless user
      user = User.new
      user.name = auth_hash.info.name
      user.email = auth_hash.info.email
      user.oauth_page = auth_hash.info.link
    end
    if auth_hash.extra.raw_info.timezone
      user.time_zone = ActiveSupport::TimeZone[auth_hash.extra.raw_info.timezone.to_i].name
    end
    user.provider = 'windowslive'
    user.oauth_uid = auth_hash.uid
    user.oauth_data = auth_hash
    # user.oauth_token = auth_hash.credentials.token
    if user.new_record?
      user.password = Devise.friendly_token[0,20]
      user.password_confirmation = user.password
    end
    user.mark_as_confirmed
    user.save
    user
  end

  # Returns Authors that have Articles
  def self.with_articles
    where("items_count > 0")
  end

  # Returns Popular Authors
  def self.popular(lim=5)
    where("items_count > 0").
    order("items_count DESC").
    limit(lim)
  end

  # Returns users with Comments Role
  def self.moderators
    role = Role.where(title: 'moderator').first
    if role
      role.users
    else
      []
    end
  end

  # Returns users with Editor Role
  def self.editors
    role = Role.where(title: 'editor').first
    if role
      role.users
    else
      []
    end
  end

  # Returns users with Admin Role
  def self.admin_users
    role = Role.where(title: 'admin').first
    if role
      role.users
    else
      []
    end
  end

  # Returns users with Security Role
  def self.security_users
    role = Role.where(title: 'security').first
    if role
      role.users
    else
      []
    end
  end

  # Returns approved Users
  def self.approved
    where("confirmed_at is not NULL")
  end
  def self.pending
    where("confirmed_at is NULL")
  end

  # Returns the last 10 approved users
  def self.recent(limit=10)
    order("id DESC").
    limit(limit)
  end

  # Returns the last 10 pending users
  def self.recent_pending(limit=10)
    pending.
    order("id DESC").
    limit(limit)
  end

  # Returns the last 10 logged in users
  def self.logged_in(limit=10)
    order("current_sign_in_at DESC").
    limit(limit)
  end

  protected

  # Callback to overwrite if confirmation is required or not.
  def confirmation_required?
    provider.blank? && oauth_data.blank?
  end

end

