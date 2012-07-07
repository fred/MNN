# Comments
ActiveAdmin.register TwitterShare do
  controller.authorize_resource
  config.comments = false
  menu parent: "Items", priority: 12, label: "Twitter Shares", if: lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, TwitterShare)
  }
  actions  :index, :destroy
  index do
    column :item
    column :status
    column "Processed At", :processed_at
    column "Scheduled At", :enqueue_at
    column :created_at
    default_actions
  end
  
end