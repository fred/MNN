# RailsAdmin config file. Generated on December 12, 2011 00:49
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  require 'i18n'
  I18n.default_locale = :en

  config.current_user_method { current_user } # auto-generated

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['Publication', 'Control Panel']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  #  ==> Authentication (before_filter)
  # This is run inside the controller instance so you can setup any authentication you need to.
  # By default, the authentication will run via warden if available.
  # and will run on the default user scope.
  # If you use devise, this will authenticate the same as authenticate_user!
  # Example Devise admin
  # RailsAdmin.config do |config|
  #   config.authenticate_with do
  #     authenticate_admin!
  #   end
  # end
  # Example Custom Warden
  # RailsAdmin.config do |config|
  #   config.authenticate_with do
  #     warden.authenticate! :scope => :paranoid
  #   end
  # end

  #  ==> Authorization
  # Use cancan https://github.com/ryanb/cancan for authorization:
  config.authorize_with :cancan

  # Or use simple custom authorization rule:
  # config.authorize_with do
  #   redirect_to root_path unless warden.user.is_admin?
  # end

  # Use a specific role for ActiveModel's :attr_acessible :attr_protected
  # Default is :default
  # config.attr_accessible_role { :default }
  # _current_user is accessible in the block if you need to make it user specific:
  # config.attr_accessible_role { _current_user.role.to_sym }

  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  config.default_items_per_page = 100

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [Attachment, Category, Comment, Item, ItemStat, RegionTag, Role, Score, Tag, Translation, User]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [Attachment, Category, Comment, Item, ItemStat, RegionTag, Role, Score, Tag, Translation, User]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field!
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Here goes your cross-section field configuration for ModelName.
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  #   show do
  #     # Here goes the fields configuration for the show view
  #   end
  #   export do
  #     # Here goes the fields configuration for the export view (CSV, yaml, XML)
  #   end
  #   edit do
  #     # Here goes the fields configuration for the edit view (for create and update view)
  #   end
  #   create do
  #     # Here goes the fields configuration for the create view, overriding edit section settings
  #   end
  #   update do
  #     # Here goes the fields configuration for the update view, overriding edit section settings
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible.
  # There can be different reasons for that:
  #  - belongs_to _id and _type (polymorphic) columns are hidden in favor of their associations
  #  - associations are hidden if they have no matchable model found (model not included or non-existant)
  #  - they are part of a bigger plan in a plugin (Devise/Paperclip) and hidden by contract
  # Some fields may be hidden depending on the section, if they aren't deemed suitable for display or edition on that section
  #  - non-editable columns (:id, :created_at, ..) in edit sections
  #  - has_many/has_one associations in list section (hidden by default for performance reasons)
  # Fields may also be marked as read_only (and thus not editable) if they are not mass-assignable by current_user

  config.model Attachment do
    # Found associations:
      configure :user, :belongs_to_association 
      configure :image
      configure :description, :text 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model Category do
    # Found associations:
    # Found columns:
      configure :title, :string 
      configure :description, :text 
      configure :created_at, :datetime 
      configure :updated_at, :datetime   #   # Sections:
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model Comment do
    # Found associations: 
      configure :owner, :belongs_to_association   #   # Found columns:
      configure :body, :text 
      configure :created_at, :datetime 
      configure :updated_at, :datetime   #   # Sections:
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model Item do
    # Found associations:
      configure :user, :belongs_to_association 
      configure :attachments, :has_many_association 
      configure :item_stats, :has_many_association 
      configure :tags, :has_and_belongs_to_many_association 
      configure :region_tags, :has_and_belongs_to_many_association   #   # Found columns:
      configure :title, :string 
      configure :highlight, :string 
      configure :body, :text 
      configure :abstract, :text 
      configure :editor_notes, :text 
      configure :slug, :string 
      configure :category_id, :integer 
      configure :updated_by, :integer 
      configure :author_name, :string 
      configure :author_email, :string 
      configure :article_source, :string 
      configure :source_url, :string 
      configure :formatting_type, :string 
      configure :locale, :string 
      configure :meta_keywords, :string 
      configure :meta_title, :string 
      configure :meta_description, :string 
      configure :status_code, :string 
      configure :draft, :boolean 
      configure :meta_enabled, :boolean 
      configure :allow_comments, :boolean 
      configure :allow_star_rating, :boolean 
      configure :protected_record, :boolean 
      configure :featured, :boolean 
      configure :member_only, :boolean 
      configure :published_at, :datetime 
      configure :expires_on, :datetime 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model ItemStat do
    # Found associations:
      configure :item, :belongs_to_association   #   # Found columns:
      configure :views_counter, :integer   #   # Sections:
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model RegionTag do
    # Found associations:
    # Found columns:
      configure :title, :string 
      configure :type, :string 
      configure :created_at, :datetime 
      configure :updated_at, :datetime   #   # Sections:
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model Role do
    # Found associations:
      configure :users, :has_and_belongs_to_many_association   #   # Found columns:
      configure :title, :string 
      configure :description, :text 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model Score do
    # Found associations:
    # Found columns:
      configure :user_id, :integer 
      configure :scorable_type, :integer 
      configure :scorable_id, :integer 
      configure :points, :integer 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model Tag do
    # Found associations:
    # Found columns:
      configure :title, :string 
      configure :type, :string 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model Translation do
    # Found associations:
    # Found columns:
      configure :locale, :string 
      configure :key, :string 
      configure :value, :text 
      configure :interpolations, :text 
      configure :is_proc, :boolean 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
  config.model User do
    # Found associations:
      configure :items, :has_many_association 
      configure :attachments, :has_many_association 
      configure :roles, :has_and_belongs_to_many_association   #   # Found columns:
      configure :email, :string 
      configure :password, :password 
      configure :password_confirmation, :password 
      configure :reset_password_sent_at, :datetime 
      configure :remember_created_at, :datetime 
      configure :sign_in_count, :integer 
      configure :current_sign_in_at, :datetime 
      configure :last_sign_in_at, :datetime 
      configure :current_sign_in_ip, :string 
      configure :last_sign_in_ip, :string 
      configure :failed_attempts, :integer 
      configure :unlock_token, :string 
      configure :locked_at, :datetime 
      configure :confirmation_token, :string 
      configure :confirmed_at, :datetime 
      configure :confirmation_sent_at, :datetime 
      configure :authentication_token, :string 
      configure :bio, :text 
      configure :name, :string 
      configure :address, :string 
      configure :twitter, :string 
      configure :diaspora, :string 
      configure :skype, :string 
      configure :gtalk, :string 
      configure :jabber, :string 
      configure :phone_number, :string 
      configure :time_zone, :string 
      configure :ranking, :integer 
    list do; end
    export do; end
    show do; end
    edit do; end
    create do; end
    update do; end
  end
end
