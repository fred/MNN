ActiveAdmin.register TwitterShare do
  config.clear_sidebar_sections!
  menu parent: "Items", priority: 12, label: "Twitter Shares"
  actions  :index, :destroy
  index title: "Twitter Shares" do
    column :item
    column :status
    bool_column :processed
    column "Processed At" do |t|
      t.processed_at.to_s(:short) if t.processed_at.present?
    end
    column "Scheduled At" do |t|
      t.enqueue_at.to_s(:short) if t.enqueue_at.present?
    end
    default_actions
  end
  controller do
    def scoped_collection
      TwitterShare.includes(:item)
    end
    def run_now
      if share = TwitterShare.where(processed: false, id: params[:id]).first
        share.enqueue
      end
    end
  end
end
