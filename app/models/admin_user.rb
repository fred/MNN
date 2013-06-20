class AdminUser < User
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :bio, :name, :address,
      :twitter, :diaspora, :skype, :gtalk, :jabber, :avatar, :phone_number, :time_zone, :type,
      :role_ids, :roles, :subscribe,  :unsubscribe, :unsubscribe_all, :upgrade, :downgrade,
      :terms_of_service, :registration_role, :gpg

  protected

  def confirmation_required?
    false
  end

end
