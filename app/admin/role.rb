ActiveAdmin.register Role do
  menu parent: "Members", priority: 50, label: "Admin Roles"

  filter :title
  form do |f|
    f.inputs "Role" do
      f.input :title
      f.input :description, as: :string
    end
    f.inputs "Users" do
      f.input :users, as: :check_boxes, member_value: :id, member_label: :title, collection: AdminUser.order("id ASC").all
    end
    f.buttons
  end
end
