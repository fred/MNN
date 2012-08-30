class EmailDelivery < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  
  after_create :enqueue
  
  protected
  
  def enqueue
    Rails.logger.info("  Queue: Delivering email for: #{self.item_id}")
    EmailDeliveryQueue.perform_at(self.send_at, self.item_id)
    Rails.logger.info("  Queue: Completed email delivery for: #{self.item_id}")
  end
end
