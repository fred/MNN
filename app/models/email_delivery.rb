class EmailDelivery < ActiveRecord::Base
  belongs_to :item
  # attr_accessible :title, :body
  
  after_create :enqueue
  
  protected
  
  def enqueue
    Rails.logger.info("  Resque: Delivering email for: #{self.item_id}")
    if Rails.env.production?
      Thread.new do
        SubscriptionMailer.new_item_email(self.item_id).deliver
      end
      # Resque.enqueue(SubscriptionQueue,self.item_id)
    end
  end
end
