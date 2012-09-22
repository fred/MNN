class FacebookQueue < BaseWorker
  delegate :url_helpers, to: 'Rails.application.routes' 

  def perform(share_id)
    share = FacebookShare.find(share_id)
    item = share.item if share
    if (share && item)
      Rails.logger.info("  Queue: Updating Facebook status for: Item ##{item.id}")
      share.post(item)
    end
  end
end
