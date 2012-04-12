class FacebookQueue
  @queue = :facebook
  
  def self.perform(share_id)
    share = Share.find(share_id)
    item = share.item if share
    if (share && item)
      Rails.logger.info("*** Resque: Updating Facebook status: #{item.twitter_status}")
      share.processed_at = Time.now
      share.status = "success"
      share.save
    end
  end
end
