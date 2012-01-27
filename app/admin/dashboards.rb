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
            "#{comment.owner.email} - #{time_ago_in_words(comment.created_at)} ago", 
            admin_user_comment_path(comment), 
            :title => comment.body
          )
        )
      end
    end
  end
  section "Spam Comments", :priority => 18 do
    ul do
      Comment.as_spam(10).collect do |comment|
        li(link_to(
            "#{comment.commentable.email} - #{time_ago_in_words(comment.created_at)} ago", 
            admin_comment_path(comment), 
            :title => comment.body
          )
        )
      end
    end
  end
  
  
  # paper_trail
  section "Recently Updated Content", :priority => 40 do
    table_for Version.order('id desc').limit(20) do
      column "Record" do |v| 
        if v.item
          link_to(
            "#{v.item_type.underscore.humanize} ##{v.item_id}",
            url_for(:controller => "admin/#{v.item.class.to_s.underscore.pluralize}", :action => 'show', :id => v.item_id)
          )
        else
          "#{v.item_type.underscore.humanize} ##{v.item_id}"
        end
      end
      column "Action" do |v| 
        v.event
      end
      column "Reason" do |v| 
        v.tag
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
  
end
