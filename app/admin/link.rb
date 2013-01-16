ActiveAdmin.register Link do
  config.clear_sidebar_sections!
  controller.authorize_resource
  config.comments = false
  menu parent: "More", priority: 62, label: "Site Links", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Link)
  }

  index title: "Links" do
    id_column
    column :title
    column :url do |link|
      link_to "URL", link.url
    end
    column :rel
    column :rev
    column "Updated" do |t|
      t.updated_at.to_s(:short)
    end
    column "Created" do |t|
      t.created_at.to_s(:short)
    end
    default_actions
  end

  form do |f|
    f.inputs "Required Information" do
      f.input :title
      f.input :url, placeholder: "http://"
      f.input :description, as: :string
    end
    f.inputs "Link Attributes" do
      f.input :rel, placeholder: "friend, co-worker, met, colleague, nofollow"
      f.input :rev
    end
    f.buttons
  end

end
