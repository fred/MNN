ActiveAdmin.register ItemStat do
  config.clear_sidebar_sections!
  config.per_page = 50 
  config.sort_order = "updated_at_desc"
  menu parent: "Items", label: 'Item Stats', priority: 3
  actions :index
  index title: "Item Statistics" do
    column "", sortable: :item_id do |t|
      t.item_id
    end
    column "Article", sortable: :item_id do |t|
      link_to t.item.title, admin_item_path(t.item) if t.item
    end
    column "Hits", :views_counter
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
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_authorization_denied_path, alert: exception.message
    end
  end
end
