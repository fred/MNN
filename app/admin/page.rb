ActiveAdmin.register Page do
  menu :priority => 100
  config.comments = false
  
  index do
    column :id
    column :title
    column :link_title
    column :slug
    column :priority
    column :active
    column :language
    column :created_at
    column :updated_at
    default_actions
  end
  
  form :partial => "form"
  controller do
    def new
      @page = Page.new
      @page.active = true
      @page.priority = 10
      @page.user_id = current_admin_user.id
    end
  end
  
end
