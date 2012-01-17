class TwitterQueue
  @queue = :twitter_queue
  
  def self.perform(share_id)
    share = Share.find(share_id)
    Rails.logger.info("*** Resque: updating twitter status with share id: #{share_id}")
  end
end
