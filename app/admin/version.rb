ActiveAdmin.register Version do
  controller.authorize_resource
  actions :index, :show
  menu priority: 99, label: "History", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Version)
  }
  config.comments = false
  index do
    id_column
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
      v.event
    end
    column "Reason" do |v| 
      v.tag
    end
    column "When" do |v| 
      v.created_at.to_s :short 
    end
    column "User" do |v| 
      user = User.where(id: v.whodunnit).first
      if user
        (link_to user.title, admin_user_path(v.whodunnit))
      else
        ""
      end
    end
    # default_actions
  end
end
