class TwitterQueue
  @queue = :share
  
  def self.perform(share_id)
    share = TwitterShare.find(share_id)
    Rails.logger.info("*** Resque: updating twitter status with share id: #{share_id}")
  end
end


class RedditQueue
  @queue = :share
  
  def self.perform(share_id)
    share = RedditShare.find(share_id)
    Rails.logger.info("*** Resque: submitting to reddit share id: #{share_id}")
  end
end
