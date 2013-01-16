# Images and File
ActiveAdmin.register Document do
  config.clear_sidebar_sections!
  controller.authorize_resource
  config.sort_order = "id_desc"
  menu parent: "Items", priority: 20, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Document)
  }

  index title: "Documents" do
    id_column
    column :title
    column "Link" do |doc|
      link_to 'Download', doc.data.url
    end
    column :content_type
    column :user
    column "Updated" do |t|
      t.updated_at.to_s(:short)
    end
    column "Created" do |t|
      t.created_at.to_s(:short)
    end
    default_actions
  end

  show title: :title do |user|
    attributes_table do
      row :title
      row "Link" do |t|
        link_to t.data.url, t.data.url
      end
      row :content_type
      row :user
      row :created_at
      row :updated_at
    end
  end
end