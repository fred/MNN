ActiveAdmin.register ItemStat do
  config.clear_sidebar_sections!
  controller.authorize_resource  
  config.sort_order = "updated_at_desc"
  menu parent: "Items", label: 'Item Page Views', priority: 3, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, ItemStat)
  }
  actions :index
  config.comments = false
  index do
    id_column
    column "Item", sortable: :item_id do |t|
      link_to t.item.title, admin_item_path(t.item) if t.item
    end
    column "Total Hits", :views_counter
    column "Last Hit", sortable: :updated_at do |t|
      t.updated_at.to_s(:short) if t.updated_at
    end
    column "First Hit", sortable: :created_at do |t|
      t.created_at.to_s(:short) if t.created_at
    end
  end
  controller do
    def scoped_collection
       ItemStat.includes(:item)
    end
  end
end
