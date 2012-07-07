class SubscriptionQueue < BaseWorker

  def perform(item_id)
    if EmailDelivery.where(item_id: item_id).first
      SubscriptionMailer.new_item_email(item_id).deliver
      Rails.logger.info("  Queue: Done delivering emails for: #{item_id}")
    else
      Rails.logger.info("  Queue: Not delivering item: #{item_id}, it has been cancelled.")
    end
  end
end