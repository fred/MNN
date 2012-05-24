class User < ActiveRecord::Base
  serialize :oauth_data, Hash
  
  mount_uploader :avatar, AvatarUploader
  mount_uploader :gpg, GpgUploader
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :bio, :name, :address,
      :twitter, :diaspora, :skype, :gtalk, :jabber, :avatar, :phone_number, :time_zone,
      :role_ids, :roles, :subscribe, :unsubscribe, :unsubscribe_all, :upgrade, :downgrade,
      :terms_of_service, :registration_role, :gpg, :facebook

  attr_accessor :subscribe, :unsubscribe, :unsubscribe_all, :upgrade, :downgrade
  
  validates_acceptance_of :terms_of_service, accept: '1', on: :create unless Rails.env.test?
  validates_exclusion_of :password, :in => lambda { |p| [p.name] }, :message => "should not be the same as your name"
  validates :email, :email_format => {:message => 'is not looking good'}, on: :create

  # validates_presence_of :password, unless: Proc.new {|user| user.oauth_token.present?}
  # validates_presence_of :password_confirmation, unless: Proc.new {|user| user.oauth_token.present?}

  # Relationships
  has_many :items #, counter_cache: true
  has_many :scores
  # has_many :comments
  has_and_belongs_to_many :roles
  has_many :subscriptions, dependent: :destroy, conditions: {item_id: nil}
  has_many :item_subscriptions, dependent: :destroy, conditions: "item_id is not NULL", class_name: "Subscription"
  
  before_save :create_subscriptions, :cancel_subscriptions, :update_subscriptions, :check_upgrade
  after_create :notify_admin

  apply_simple_captcha

  def notify_admin
    Resque.enqueue(MailerQueue,self.id)
  end

  def check_upgrade
    if (self.upgrade.to_s == "1" or self.upgrade == true) && !self.is_admin?
      self.type = "AdminUser"
    elsif (self.downgrade.to_s == "1" or self.downgrade == true) && self.is_admin?
      self.type = "User"
    end
    true
  end

  def is_admin?
    self.type == "AdminUser"
  end
  
  def title
    if self.name.present?
      str = self.name
    else
      str = self.email
    end
    str
  end
  
  def has_image?
    self.avatar?
  end

  def main_image(version=:thumb)
    if has_image?
      avatar.url(version)
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
      self.subscriptions.last.update_attribute(:email, self.email)
    end
    true
  end
  
  def cancel_subscriptions
    if (self.unsubscribe_all.to_s == "1" or self.unsubscribe_all == true) && !self.subscriptions.empty?
      self.subscriptions.destroy_all
      self.item_subscriptions.destroy_all
    end
    true
  end



  def self.find_or_create_from_oauth(auth_hash, session=nil)
    user = where(email: auth_hash.info.email).first
    unless user
      user = User.new
      user.name = auth_hash.info.name
      user.email = auth_hash.info.email
      user.facebook = auth_hash.info.urls.Facebook
      user.fbuid = auth_hash.uid
      user.password = auth_hash.credentials.token
      user.password_confirmation = auth_hash.credentials.token
    end
    user.oauth_token = auth_hash.credentials.token
    user.oauth_data = auth_hash
    user.save
    user
  end


  # Returns users with Admin Role
  def self.admin_users
    Role.where(title: 'admin').first.users
  end
  # Returns users with Security Role
  def self.security_users
    Role.where(title: 'security').first.users
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
    approved.
    order("current_sign_in_at DESC").
    limit(limit)
  end  
  
end

