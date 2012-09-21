class FacebookQueue < BaseWorker

  def perform(share_id)
    share = Share.find(share_id)
    item = share.item if share
    if (share && item)
      Rails.logger.info("  Queue: Updating Facebook status: #{item.twitter_status}")
      share.processed_at = Time.now

      pages = FbGraph::User.me(APP_CONFIG['facebook_access_token']).accounts.firs

      res = pages.feed!(
        message: item.title,
        link: item_path(item),
        description: item.abstract
      )

      if res
        share.status = "success"
        share.save
      end
    end
  end
end
