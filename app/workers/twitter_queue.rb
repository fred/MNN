class TwitterQueue < BaseWorker

  def perform(share_id)
    if (share = TwitterShare.where(processed: false, id: share_id).first) && share.item
      item = share.item 
      if (share && item && Twitter.update(item.twitter_status))
        Rails.logger.info("  Queue: Updating Twitter status: #{item.twitter_status}")
        share.processed_at = Time.now
        share.processed = true
        share.status = "success"
        share.save
      end
    else
      Rails.logger.info("  Queue: Twitter share not found for share ID: #{share.id}")
    end
  end
end
