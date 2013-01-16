# Comments
ActiveAdmin.register FacebookShare do
  config.clear_sidebar_sections!
  controller.authorize_resource
  config.comments = false
  menu parent: "Items", priority: 13, label: "Facebook Shares", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, FacebookShare)
  }
  actions  :index, :destroy
  index title: "Facebook Shares" do
    column :item
    column :status do |share|
      link_to(share.status, share.status_link, target: "_blank", title: "Open post in facebook") if share.status_link
    end
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
       FacebookShare.includes(:item)
    end
  end
end