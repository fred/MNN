class SubscriptionQueue < BaseWorker

  def perform(item_id)
    Rails.logger.info("  Queue: Delivering emails for: #{item_id}")
    SubscriptionMailer.new_item_email(item_id).deliver
    Rails.logger.info("  Queue: Done delivering emails for: #{item_id}")
  end
end