ActiveAdmin.register Link do
  controller.authorize_resource
  config.comments = false
  menu parent: "Settings", priority: 120, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Link)
  }

  index do
    id_column
    column :title
    column :priority
    column :url do |link|
      link_to "URL", link.url
    end
    column :created_at
    column :updated_at
    default_actions
  end

end
