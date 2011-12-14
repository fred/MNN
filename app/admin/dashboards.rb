ActiveAdmin::Dashboards.build do

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     div do
  #       render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #     end
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.  
  
  
  ActiveAdmin.register Item do
    menu :priority => 1
    index do
      column :id
      column :user
      column :title
      column :draft
      column :featured
      column :status_code
      column :updated_at
      column :published_at
      column :expires_on
      default_actions
    end
    form do |f|
      f.inputs "Required Main Information" do
        f.input :category, :as => :select, 
                :label_method => 'title', 
                :value_method => :id, 
                :label => "Section",
                :required => true
        f.input :title, :label => "Main Title", :required => true
        f.input :highlight, :label => "Article Highlight", :required => true
        f.input :body, :label => "Main Content", :required => true
      end
      
      f.inputs "Tags" do
        f.input :general_tags, :as => :check_boxes, :collection => GeneralTag.find(:all, :order => "title ASC")
        f.input :region_tags, :as => :check_boxes, :collection => RegionTag.find(:all, :order => "title ASC")
        f.input :country_tags, :as => :check_boxes, :collection => CountryTag.find(:all, :order => "title ASC")
      end
      
      f.inputs "Optional" do
        f.input :author_name
        f.input :author_email
        f.input :source_url
      end
      f.inputs "Status Codes" do
        f.input :draft
        f.input :featured, :label => "Highlight"
        f.input :allow_comments
        f.input :allow_star_rating
        f.input :protected_record, :label => "Locked"
      end
      
      f.inputs "Dates" do
        f.input :published_at, :label => "When to go live", :time => true
        f.input :expires_on, :label => "Expiration Date", :time => true
        # f.input :published_at, :label => "When to go live", :as => :datepicker, :time => true
        # f.input :expires_on, :label => "Expiration Date", :as => :datepicker, :time => true
      end
      
      f.buttons
    end
  end
  
  # Comments
  ActiveAdmin.register Comment, :as => "UserComment"  do
    menu :priority => 4, :label => "Comments"
  end
  
  # Categories
  ActiveAdmin.register Category do
    menu :priority => 10
  end
  
  
  # TAGS
  ActiveAdmin.register GeneralTag do
    menu :parent => "Tags", :priority => 11
  end
  ActiveAdmin.register RegionTag do
    menu :parent => "Tags", :priority => 13
  end
  ActiveAdmin.register CountryTag do
    menu :parent => "Tags", :priority => 15
  end

  # Images and File
  ActiveAdmin.register Attachment do
    menu :priority => 20
  end
  
  
  # USER
  ActiveAdmin.register User do
    menu :parent => "Members", :priority => 30
    # filter :name
    # filter :email
    # filter :ranking
    index do
      column :id
      column :name
      column :email
      column :ranking
      column :role_titles
      default_actions
    end

    # show do
    #   user.name
    #   user.email
    #   user.ranking
    #   user.diaspora
    #   user.gtalk
    #   user.jabber
    #   user.skype
    #   user.twitter
    #   user.roles
    # end
    
    form do |f|
      f.inputs "User Info" do
        f.input :email
        f.input :name
        f.input :bio
      end
      f.inputs "Contact Info" do
        f.input :address
        f.input :skype
        f.input :twitter
        f.input :diaspora
        f.input :jabber
        f.input :gtalk
        f.input :phone_number
        f.input :time_zone
      end
      f.inputs "Roles" do
        f.input :roles, :as => :select, :label_method => 'title' , :value_method => :id
      end
      f.buttons
    end
  end
  
  # Scores
  ActiveAdmin.register Score do
    menu :parent => "Members", :priority => 32
  end
  
  # Roles
  ActiveAdmin.register Role do
    menu :parent => "Members", :priority => 34
    filter :title
    form do |f|
      f.inputs "Role" do
        f.input :title
        f.input :description
      end
      f.inputs "Users" do
        f.input :users, :as => :select, :label_method => 'title' , :value_method => :id
      end
      f.buttons
    end
  end
  
  ActiveAdmin.register Translation do
    menu :priority => 40
  end
  

  # paper_trail
  section "Recently updated content" do
    table_for Version.order('id desc').limit(20) do
      column "Item" do |v| v.item end
      column "Type" do |v| v.item_type.underscore.humanize end
      column "Modified at" do |v| v.created_at.to_s :long end
      
      column "User" do |v| 
        user = User.where(:id => v.whodunnit).first
        if user
          (link_to user.title, admin_user_path(v.whodunnit))
        else
          ""
        end
      end
      
    end
  end

end
