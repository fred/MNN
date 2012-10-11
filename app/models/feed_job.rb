class FeedJob < JobStat

  after_create :enqueue

  def self.last_job
    order("updated_at DESC").first
  end

  def self.should_refresh?
    last.updated_at < Time.now-1.hour
  end

  protected

  def enqueue
    Rails.logger.info("  Queue: Enqueueing Feed Site generation")
    FeedSiteQueue.perform_in(self.enqueue_at,self.id)
  end

end