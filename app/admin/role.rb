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