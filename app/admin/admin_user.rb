# USER
ActiveAdmin.register AdminUser do
  config.comments = false
  menu :parent => "Members", :priority => 24
  index do
    column :id
    column :name
    column :email
    column :ranking
    column :role_titles
    default_actions
  end
  form do |f|
    f.inputs "User Info" do
      f.input :email
      f.input :name
      f.input :bio
    end
    f.inputs "Contact Info" do
      f.input :address
      f.input :skype
      f.input :twitter
      f.input :diaspora
      f.input :jabber
      f.input :gtalk
      f.input :phone_number
      f.input :time_zone
    end
    f.inputs "Roles" do
      f.input :roles, :as => :select, :label_method => 'title' , :value_method => :id
    end
    f.buttons
  end
end