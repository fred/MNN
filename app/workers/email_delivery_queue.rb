class EmailDeliveryQueue < BaseWorker

  def perform(item_id)
    if (email = EmailDelivery.where(item_id: item_id).first)
      if SubscriptionMailer.new_item_email(item_id).deliver
        email.update_attributes(delivered: true)
      end
      Rails.logger.info("  Queue: Done delivering emails for: #{item_id}")
    else
      Rails.logger.info("  Queue: Not delivering item: #{item_id}, it has been cancelled.")
      true
    end
  end

end