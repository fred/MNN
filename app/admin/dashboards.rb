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
  #   section "Recent Posts", priority: 10
  #   section "Recent User", priority: 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.  

  ##################
  ### DASHBOARD ####
  ##################

  # action_item do
  #   link_to "Back to Site", root_path
  # end

  section "Popular Searches", priority: 1 do
    table_for Query.popular.limit(10) do
      column "Query" do |t|
        link_to t.keyword, search_path(q: t.keyword)
      end
      column "Hits" do |t|
        t.count
      end
      column "Lang" do |t|
        t.locale
      end
    end
  end

  section "Suspicious Comments", priority: 2 do
    if controller.current_ability.can?(:read, Comment)
      table_for Comment.suspicious(10) do
        column "User" do |t|
          if t.owner
            link_to t.name, admin_user_path(t.owner), class: "suspicious_#{t.suspicious?} spam_#{t.marked_spam?}"
          else
            t.owner_id
          end
        end
        column "Message" do |t|
          link_to sanitize(t.body, tags: '', attributes: '').truncate(80),
            admin_comment_path(t),
            class: "suspicious_#{t.suspicious?} spam_#{t.marked_spam?}"
        end
        column "Item" do |t|
          if t.commentable && t.commentable_type == "Item"
            link_to t.commentable.title.truncate(40), admin_item_path(t.commentable), title: t.commentable.title
          elsif t.commentable && t.commentable_type == "Comment"
            link_to t.commentable.commentable.title.truncate(40), admin_item_path(t.commentable.commentable)
          end
        end
        column "Time" do |t|
          "#{time_ago_in_words(t.created_at)} ago"
        end
        column "IP" do |t|
          link_to(t.user_ip, "http://www.geoiptool.com/en/?IP=#{t.user_ip}", target: "_blank")
        end
        column "Action" do |t|
          link_to "Delete", admin_comment_path(t), method: 'delete', confirm: "Are you sure you want to delete this comment?", remote: true
        end
      end
    end
  end

  section "Spam Comments", priority: 2 do
    if controller.current_ability.can?(:read, Comment)
      table_for Comment.as_spam(10) do
        column "User" do |t|
          if t.owner
            link_to t.owner.title, admin_user_path(t.owner), class: "suspicious_#{t.suspicious?} spam_#{t.marked_spam?}"
          else
            t.owner_id
          end
        end
        column "Message" do |t|
          link_to sanitize(t.body, tags: '', attributes: '').truncate(80),
            admin_comment_path(t),
            class: "suspicious_#{t.suspicious?} spam_#{t.marked_spam?}"
        end
        column "Item" do |t|
          if t.commentable && t.commentable_type == "Item"
            link_to t.commentable.title.truncate(40), admin_item_path(t.commentable)
          elsif t.commentable && t.commentable_type == "Comment"
            link_to t.commentable.commentable.title.truncate(40), admin_item_path(t.commentable.commentable)
          end
        end
        column "Time" do |t|
          "#{time_ago_in_words(t.created_at)} ago"
        end
        column "IP" do |t|
          link_to(t.user_ip, "http://www.geoiptool.com/en/?IP=#{t.user_ip}", target: "_blank")
        end
        column "Action" do |t|
          link_to "Delete", admin_comment_path(t), method: 'delete', confirm: "Are you sure you want to delete this comment?", remote: true
        end
      end
    end
  end


  ### ITEMS
  section "Draft Items", priority: 6 do
    if controller.current_ability.can?(:read, Item)
      ul do
        Item.recent_drafts(10).collect do |item|
          li link_to("#{item.id} - #{item.title} (#{item.category_title}) - #{time_ago_in_words(item.updated_at)} ago", admin_item_path(item))
        end
      end
    end
  end

  ### USERS
  section "Newly Registered User", priority: 16 do
    if controller.current_ability.can?(:read, User)
      table_for User.recent(10).collect do
        column "Name" do |user|
          link_to_if(user.name.present?,user.name.to_s, admin_user_path(user))
        end
        column "Email" do |user|
          link_to(user.email, admin_user_path(user))
        end
        column "Provider" do |user|
          user.provider if user.provider.present?
        end
        column "Date" do |user|
          "#{time_ago_in_words(user.created_at)} ago"
        end
      end
    end
  end
  ### USERS
  section "Recently Logged in Users", priority: 20 do
    if controller.current_ability.can?(:read, User)
      table_for User.logged_in(10).collect do
        column "Name" do |user|
          link_to_if(user.name.present?,user.name.to_s, admin_user_path(user))
        end
        column "Email" do |user|
          link_to(user.email, admin_user_path(user))
        end
        column "Last Activity" do |user|
          time_ago_in_words(user.current_sign_in_at)
        end
        column "Login IP" do |user|
          user.current_sign_in_ip
        end
      end
    end
  end

  ### HISTORY
  section "Database History", priority: 24 do
    if controller.current_ability.can?(:read, Version)
      table_for Version.order('id desc').limit(16) do
        column "Record" do |v| 
          if v.item
            link_to(
              "#{v.item_type.underscore.humanize} ##{v.item_id}",
              url_for(controller: "admin/#{v.item.class.to_s.underscore.pluralize}", action: 'show', id: v.item_id)
            )
          else
            "#{v.item_type.underscore.humanize} ##{v.item_id}"
          end
        end
        column "Action" do |v|
          link_to(v.event,admin_version_path(v))
        end
        column "Reason" do |v|
          v.tag
        end
        column "When" do |v|
          "#{time_ago_in_words(v.created_at)} ago"
        end
        column "User" do |v|
          user = User.where(id: v.whodunnit).first
          if user
            (link_to user.title, admin_user_path(v.whodunnit))
          else
            ""
          end
        end
        column "View" do |v|
          link_to('Details',admin_version_path(v))
        end
      end
    end
  end


  ### COMMENTS

  section "Lastest Comments", priority: 32 do
    if controller.current_ability.can?(:read, Comment)
      table_for Comment.recent(10) do
        column "User" do |t|
          if t.owner
            link_to t.name, admin_user_path(t.owner), class: "suspicious_#{t.suspicious?} spam_#{t.marked_spam?}"
          else
            t.owner_id
          end
        end
        column "Message" do |t|
          link_to sanitize(t.body, tags: '', attributes: '').truncate(80),
            admin_comment_path(t),
            class: "suspicious_#{t.suspicious?} spam_#{t.marked_spam?}"
        end
        column "Item" do |t|
          if t.commentable && t.commentable_type == "Item"
            link_to t.commentable.title.truncate(34), admin_item_path(t.commentable), title: t.commentable.title
          elsif t.commentable && t.commentable_type == "Comment"
            link_to t.commentable.commentable.title.truncate(30), admin_item_path(t.commentable.commentable)
          end
        end
        column "Time" do |t|
          "#{time_ago_in_words(t.created_at)} ago"
        end
        column "IP" do |t|
          link_to(t.user_ip, "http://www.geoiptool.com/en/?IP=#{t.user_ip}", target: "_blank")
        end
      end
    end
  end

end


module ActiveAdmin
  module Views
    class Footer < Component
      def build
        super id: "footer"
        para "Worldmathaba Admin -- #{Time.now.to_s(:long)}"
      end
    end
  end
end
