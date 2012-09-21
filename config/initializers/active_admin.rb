ActiveAdmin.setup do |config|

  config.default_per_page = 24

  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "WorldMathaba"

  config.dashboard_columns = 1

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to. 
  #
  # eg: 
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  config.default_namespace = :admin


  # == User Authentication
  #
  # Active Admin will automatically call an authentication 
  # method in a before filter of all controller actions to 
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the controller.
  config.authentication_method = :authenticate_admin_user!


  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # to return the currently logged in user.
  config.current_user_method = :current_admin_user


  # == Admin Comments
  #
  # Admin comments allow you to add comments to any model for admin use.
  # Admin comments are enabled by default.
  #
  # Default:
  config.allow_comments = false


  # == Admin Notes
  # 
  # Admin notes allow you to add notes to any model
  #
  # Admin notes are enabled by default, but can be disabled
  # by uncommenting this line:
  #
  config.admin_notes = false


  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources from here. 
  #
  # config.before_filter :do_something_awesome


  # == Register Stylesheets & Javascripts
  #
  # We recomend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  # config.register_stylesheet 'admin.css'
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'

  # Set the action to call for the root path. You can set different
  # roots for each namespace.
  # Default:
  # config.root_to = 'dashboard#index'

  # == Batch Actions
  # Enable and disable Batch Actions
  config.batch_actions = false

  # == CSV options
  # Set the CSV builder separator (default is ",")
  # config.csv_column_separator = ','</pre>
end



module ActiveAdmin
  module Views

    BOOL_LAMBDA = ->(attribute, model) { (model[attribute] ? '&#x2714;' : '&#x2717;').html_safe }

    class TableFor
      def bool_column(attribute)
        column attribute, &BOOL_LAMBDA.curry[attribute]
      end
    end

    class AttributesTable
      def bool_row(attribute)
        row attribute, &BOOL_LAMBDA.curry[attribute]
      end
    end
  end
end
