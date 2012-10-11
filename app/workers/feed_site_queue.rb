class FeedSiteQueue < BaseWorker

  def perform(job_id)
    @time = Time.now
    Sidekiq.logger.info("[Feed] Start processing all feeds.")
    FeedSite.refresh_all
    Sidekiq.logger.info("[Feed] Processed all feeds in #{Time.now.to_i - @time.to_i} seconds.")
    if job_id && @feed_job = FeedJob.find(job_id)
      @feed_job.processed = true
      @feed_job.save
    end
  end
end
