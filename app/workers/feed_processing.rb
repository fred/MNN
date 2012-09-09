class FeedProcessing < BaseWorker
  def perform
    @time = Time.now
    Sidekiq.logger.info("  Queue: Start processing all feeds.")
    FeedSite.refresh
    Sidekiq.logger.info("  Queue: Processed all feeds in #{Time.now.to_i - @time.to_i} seconds.")
  end
end
