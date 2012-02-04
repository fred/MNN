# USER
ActiveAdmin.register User do
  controller.authorize_resource
  config.comments = false
  menu :parent => "Members", :priority => 24
  form :partial => "form"
  # show do
  #   render "show"
  # end
  index do
    column :id
    column :name
    column :email
    column :ranking
    column :role_titles
    column :type
    column "Logins", :sign_in_count
    default_actions
  end
end