class DiggQueue
  @queue = :digg
  
  def self.perform(share_id)
    share = Share.find(share_id)
    Rails.logger.info("*** Resque: posting to Digg with share id: #{share.item_id}")
  end
end
