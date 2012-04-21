class EmailDelivery < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  
  after_create :enqueue
  
  protected
  
  def enqueue
    Rails.logger.info("  Resque: Delivering email for: #{self.item_id}")
    if Rails.env.production?
      # Thread.new do
      #   SubscriptionMailer.new_item_email(self.item_id).deliver
      # end
      Resque.enqueue_at(self.send_at, SubscriptionQueue, self.item_id)
      Rails.logger.info("  Resque: Completed email delivery for: #{self.item_id}")
    end
  end
end
