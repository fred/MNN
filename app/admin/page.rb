ActiveAdmin.register Page do
  config.clear_sidebar_sections!
  controller.authorize_resource

  menu parent: "Settings", priority: 100, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Page)
  }
  config.sort_order = "updated_at_desc"
  config.comments = false
  
  index title: "Pages" do
    id_column
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
  
  form partial: "form"
  
  show do
    render "show"
  end
  
  controller do
    def new
      @page = Page.new
      @page.active = true
      @page.priority = 10
      @page.user_id = current_admin_user.id
      authorize! :create, Page
    end

    def scoped_collection
      Page.includes(:user, :language)
    end
  end
  
end
