class FeedSiteQueue < BaseWorker

  def perform
    @time = Time.now
    Sidekiq.logger.info("  Feeds: Start processing all feeds.")
    FeedSite.refresh_all
    Sidekiq.logger.info("  Feeds: Processed all feeds in #{Time.now.to_i - @time.to_i} seconds.")
  end
end
