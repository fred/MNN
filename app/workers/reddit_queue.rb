class RedditQueue < BaseWorker

  def perform(share_id)
    share = Share.find(share_id)
    Rails.logger.info("  Queue: posting item to reddit with share id: #{share.item_id}")
  end
end
