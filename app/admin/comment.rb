# Comments
ActiveAdmin.register Comment do
  controller.authorize_resource
  config.comments = false
  menu priority: 8, label: "Comments", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Comment)
  }

  index do
    selectable_column
    column "User", sortable: :owner_id do |t|
      if t.owner
        link_to t.owner.title, admin_user_path(t.owner), class: "suspicious_#{t.suspicious?} spam_#{t.marked_spam?}"
      end
    end
    column "Message", sortable: false do |t|
      link_to t.body.truncate(80), admin_comment_path(t), class: "suspicious_#{t.suspicious?} spam_#{t.marked_spam?}"
    end
    column "Live", :approved do |t|
      bool_symbol t.approved
    end
    column "Spam", :marked_spam do |t|
      bool_symbol t.marked_spam
    end
    bool_column :suspicious
    column "Date", :created_at do |t|
      time_ago_in_words(t.created_at)
    end
    default_actions
  end

  form do |f|
    f.inputs 'Editing Comment' do
      f.input :body, as: :text, input_html: {rows: 5}
      f.input :approved
      f.input :marked_spam
      f.input :suspicious
      f.input :approved_by, as: :select, collection: AdminUser.all.map{ |t| [ t.title, t.id ] }, include_blank: true
    end
    f.buttons
  end


  show title: :display_name do
    attributes_table do
      row "User", &->(t){link_to_if t.owner, t.display_name, admin_user_path(t.owner_id)}
      row :user_ip, &->(t){link_to(t.user_ip, "http://www.geoiptool.com/en/?IP=#{t.user_ip}", target: "_blank")}
      row :user_agent
      bool_row :approved
      bool_row "Spam", &:marked_spam
      bool_row :suspicious
      row :created_at
      row :updated_at
      row 'Comment', &->(t){t.body.html_safe}
      row 'Comment HTML', &->(t){t.body}
    end
  end
  
  controller do
    def destroy
      @comment = Comment.find(params[:id])
      authorize! :destroy, @comment
      @old_id = @comment.id
      @comment.destroy if @comment
      respond_to do |format|
        format.html {redirect_to admin_comments_path}
        format.js {render layout: false}
        format.json
        format.xml
      end
    end
  end
  
end