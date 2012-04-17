require 'resque-history'

class TwitterQueue
  extend Resque::Plugins::History
  @queue = :twitter
  @max_history = 100
  
  def self.perform(share_id)
    share = Share.find(share_id)
    item = share.item if share
    if (share && item && Twitter.update(item.twitter_status))
      Rails.logger.info("*** Resque: Updating twitter status: #{item.twitter_status}")
      share.processed_at = Time.now
      share.status = "success"
      share.save
    end
  end
end
