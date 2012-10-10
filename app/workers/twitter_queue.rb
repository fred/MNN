class TwitterQueue < BaseWorker

  def perform(share_id)
    share = TwitterShare.find(share_id)
    if share && share.item
      item = share.item 
      if (share && item && Twitter.update(item.twitter_status))
        Rails.logger.info("  Queue: Updating Twitter status: #{item.twitter_status}")
        share.processed_at = Time.now
        share.status = "success"
        share.save
      end
    else
      Rails.logger.info("  Queue: Twitter share not found for share ID: #{share.id}")
    end
  end
end
