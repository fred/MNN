# Comments
ActiveAdmin.register TwitterShare do
  config.comments = false
  menu :parent => "Items", :priority => 12, :label => "Twitter Shares"
  actions  :index
  index do
    id_column
    column :item
    column :status
    column "Job Time", :enqueue_at
    column "Completed At", :processed_at
    column :created_at
  end
  
end