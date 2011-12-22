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
  
  
  ##################
  ### DASHBOARD ####
  ##################
  
  section "Recently Updated Items", :priority => 2 do
    ul do
      Item.recent_updated(10).collect do |item|
        li(
          link_to("#{item.category_title} - #{item.title} - #{time_ago_in_words(item.updated_at)} ago",
          admin_item_path(item))
        )
      end
    end
  end
  
  section "Draft Items", :priority => 8 do
    ul do
      Item.recent_drafts(10).collect do |item|
        li link_to("#{item.category_title} - #{item.title} - #{time_ago_in_words(item.updated_at)} ago", admin_item_path(item))
      end
    end
  end
  
  section "Pending Items", :priority => 14 do
    ul do
      Item.pending(10).collect do |item|
        li link_to("#{item.category_title} - #{item.title}", admin_item_path(item))
      end
    end
  end

  ### USERS
  section "Pending Users", :priority => 4 do
    ul do
      User.recent_pending(10).collect do |user|
        li link_to(user.title, admin_user_path(user))
      end
    end
  end
  section "New Users", :priority => 10 do
    ul do
      User.recent(10).collect do |user|
        li link_to(user.title, admin_user_path(user))
      end
    end
  end
  section "Recent Logged in Users", :priority => 16 do
    ul do
      User.logged_in(10).collect do |user|
        li(
          link_to(
            "#{user.title} - #{time_ago_in_words(user.current_sign_in_at)} ago", 
            admin_user_path(user)
          )
        )
      end
    end
  end

  ### COMMENTS ###
  section "Recent Comments", :priority => 6 do
    ul do
      Comment.recent(10).collect do |comment|
        li(link_to(
            "#{comment.commentable.email} Wrote #{time_ago_in_words(comment.created_at)}:", 
            admin_comment_path(comment), 
            :title => comment.body
          )
        )
        li "#{comment.body.truncate(50)} ago"
      end
    end
  end
  section "Pending Comments", :priority => 12 do
    ul do
      Comment.pending(10).collect do |comment|
        li(link_to(
            "#{comment.commentable.email} Wrote #{time_ago_in_words(comment.created_at)}:", 
            admin_comment_path(comment), 
            :title => comment.body
          )
        )
        li "#{comment.body.truncate(50)} ago"
      end
    end
  end
  section "Spam Comments", :priority => 18 do
    ul do
      Comment.as_spam(10).collect do |comment|
        li(link_to(
            "#{comment.commentable.email} Wrote #{time_ago_in_words(comment.created_at)}:", 
            admin_comment_path(comment), 
            :title => comment.body
          )
        )
        li "#{comment.body.truncate(50)} ago"
      end
    end
  end
  
  
  # paper_trail
  section "Recently Updated Content", :priority => 40 do
    table_for Version.order('id desc').limit(10) do
      column "Type" do |v| 
        v.item_type.underscore.humanize
      end
      column "Action" do |v| 
        v.event
      end
      column "When" do |v| 
        v.created_at.to_s :short 
      end
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
  
  
  
  # MODELS
  ActiveAdmin.register Item do
    menu :priority => 1
    show do
      render "show"
    end
    index do
      column :id
      column :user
      column :title
      column :draft
      column :featured
      column "Status", :status_code
      column "Updated" do |item|
        item.updated_at.to_s(:short)
      end
      column "Published" do |item|
        item.published_at.to_s(:short)
      end
      default_actions
    end
    form :partial => "form"
  end
  
  # Comments
  ActiveAdmin.register Comment, :as => "UserComment" do
    config.comments = false
    menu :priority => 4, :label => "Comments"
  end
  
  # Categories
  ActiveAdmin.register Category do
    config.comments = false
    menu :priority => 10
  end
  
  
  # TAGS
  ActiveAdmin.register GeneralTag do
    config.comments = false
    menu :parent => "Tags", :priority => 15
  end
  ActiveAdmin.register RegionTag do
    config.comments = false
    menu :parent => "Tags", :priority => 17
  end
  ActiveAdmin.register CountryTag do
    config.comments = false
    menu :parent => "Tags", :priority => 19
  end

  # Images and File
  ActiveAdmin.register Attachment do
    menu :priority => 22
  end
  
  
  # USER
  ActiveAdmin.register User do
    config.comments = false
    menu :parent => "Members", :priority => 24
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
    config.comments = false
    menu :parent => "Members", :priority => 35
  end
  
  # Roles
  ActiveAdmin.register Role do
    config.comments = false
    menu :parent => "Members", :priority => 50
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
    config.comments = false
    menu :priority => 45
  end


  # ActiveAdmin.register Version do
  #   config.comments = false
  #   menu :priority => 50
  # end
  
end
