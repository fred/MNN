ActiveAdmin.register ItemStat do
  controller.authorize_resource
  
  config.sort_order = "updated_at_desc"
  actions :index
  menu :parent => "Items", :priority => 3
  config.comments = false
  index do
    column :id
    column "Item", :sortable => :item_id do |t|
      link_to t.item.title, admin_item_path(t.item) if t.item
    end
    column "Total Hits", :views_counter
    column "Last Hit" do |t|
      t.updated_at.to_s(:short) if t.updated_at
    end
    column "First Hit" do |t|
      t.created_at.to_s(:short) if t.created_at
    end
  end
end
