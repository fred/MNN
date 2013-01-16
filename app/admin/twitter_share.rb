# Comments
ActiveAdmin.register TwitterShare do
  config.clear_sidebar_sections!
  controller.authorize_resource
  config.comments = false
  menu parent: "Items", priority: 12, label: "Twitter Shares", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, TwitterShare)
  }
  actions  :index, :destroy
  index title: "Twitter Shares" do
    column :item
    column :status
    column "Processed At" do |t|
      t.processed_at.to_s(:short)
    end
    column "Scheduled At" do |t|
      t.enqueue_at.to_s(:short)
    end
    default_actions
  end
  controller do
    def scoped_collection
       TwitterShare.includes(:item)
    end
  end
end