# Comments
ActiveAdmin.register Comment do
  controller.authorize_resource
  config.comments = false
  menu priority: 8, label: "Comments", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Comment)
  }

  index do
    selectable_column
    id_column
    column "Message", sortable: false do |t|
      t.body.truncate(50)
    end
    column "User", sortable: :owner_id do |t|
      if t.owner
        link_to t.owner.title, admin_user_path(t.owner)
      end
    end
    column "Live", :approved
    column "Spam", :marked_spam
    column :user_ip do |t|
      link_to(t.user_ip, "http://www.geoiptool.com/en/?IP=#{t.user_ip}", target: "_blank")
    end
    column "Date", :created_at do |t|
      t.created_at.to_s(:short)
    end
    default_actions
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