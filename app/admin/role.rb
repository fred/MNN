# Roles
ActiveAdmin.register Role do
  controller.authorize_resource
  
  config.comments = false
  menu :parent => "Members", :priority => 50
  filter :title
  form do |f|
    f.inputs "Role" do
      f.input :title
      f.input :description
    end
    f.inputs "Users" do
      f.input :users, :as => :check_boxes, :member_value => :id, :member_label => :title
    end
    f.buttons
  end
end