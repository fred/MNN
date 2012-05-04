# Roles
ActiveAdmin.register Role do
  controller.authorize_resource
  
  menu parent: "Members", priority: 50, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Role)
  }
  
  config.comments = false

  filter :title
  form do |f|
    f.inputs "Role" do
      f.input :title
      f.input :description
    end
    f.inputs "Users" do
      f.input :users, as: :check_boxes, :member_value => :id, :member_label => :title
    end
    f.buttons
  end
end