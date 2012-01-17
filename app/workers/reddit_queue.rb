class RedditQueue
  @queue = :reddit_queue
  
  def self.perform(share_id)
    share = Share.find(share_id)
    Rails.logger.info("*** Resque: posting item to reddit with share id: #{share_id}")
  end
end
