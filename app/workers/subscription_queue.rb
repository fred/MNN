require 'resque-history'

class SubscriptionQueue
  extend Resque::Plugins::History
  @queue = :subscriptions
  @max_history = 200
  
  def self.perform(item_id)
    Rails.logger.info("  Resque: Delivering emails for: #{item_id}")
    SubscriptionMailer.new_item_email(item_id).deliver
    Rails.logger.info("  Resque: Done delivering emails for: #{item_id}")
  end
end