class TwitterQueue
  @queue = :twitter_queue
  
  def self.perform(share_id)
    share = Share.find(share_id)
    Rails.logger.info("*** Resque: updating twitter status with share id: #{share.item_id}")
    share.processed_at = Time.now
    share.status = "success"
    share.save
  end
end
