ActiveAdmin.register Page do
  config.clear_sidebar_sections!
  controller.authorize_resource

  menu parent: "More", priority: 60, label: "Static Pages", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Page)
  }
  config.sort_order = "updated_at_desc"
  config.comments = false

  action_item only: [:show, :edit] do
    link_to('View on site', page_path(page), 'data-no-turbolink' => true)
  end
  
  index title: "Pages" do
    id_column
    column :title
    column :link_title
    column :slug
    column :priority
    bool_column :active
    bool_column :member_only
    column :language
    column "Updated" do |t|
      t.updated_at.to_s(:short)
    end
    column "Created" do |t|
      t.created_at.to_s(:short)
    end
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
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_access_denied_path, alert: exception.message
    end
  end
end
