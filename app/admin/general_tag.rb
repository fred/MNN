ActiveAdmin.register GeneralTag do
  before_filter only: :index do
    @per_page = 12
  end
  controller.authorize_resource
  config.comments = false
  menu parent: "Tags", priority: 15, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Tag)
  }
  form partial: "form"

  index do
    id_column
    column :title
    column :slug do |tag|
      link_to tag.slug, tag_path(tag)
    end
    column "Items" do |tag|
      tag.items.count
    end
    column :created_at
    column :updated_at
    default_actions
  end
  # def scoped_collection
  #   Tag.includes(:items)
  # end
end
