class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :confirmable, 
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  
  # Relationships
  has_many :items
  has_many :scores
  # has_many :comments
  has_many :attachments
  has_and_belongs_to_many :roles
  
  accepts_nested_attributes_for :attachments, :allow_destroy => true
  
  
  def title
    if self.name
      str = self.name
    else
      str = self.email
    end
    str
  end
  
  def has_image?
    !self.attachments.empty? && self.attachments.first && self.attachments.first.image
  end
  
  def has_role?(role)
    self.roles.where(:title => role.to_s.downcase).count > 0
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
  
  
  
  
  # Returns approved Users
  def self.approved
    where("confirmed_at is not NULL")
  end
  def self.pending
    where("confirmed_at is NULL")
  end
  
  # Returns the last 10 approved users
  def self.recent(limit=10)
    approved.
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

