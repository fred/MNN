class FacebookQueue < BaseWorker

  def perform(share_id)
    share = FacebookShare.find(share_id)
    if share && share.item
      item = share.item
      if (share && item && share.post(item))
        Rails.logger.info("  Queue: Updating Facebook status for Item: ##{item.id}")
      end
    else
      Rails.logger.info("  Queue: Facebook share not found for share ID: #{share.id}")
    end
  end
end
