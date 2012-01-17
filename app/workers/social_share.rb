class SocialShare
  @queue = :share
  def self.perform(share_id)
    share = Share.find(share_id)
    Rails.logger.info("*** Resque: performing share for: #{share_id}")
  end
end