require "job_stat.rb" # requiring parent model for threadsafe!

class SitemapJob < JobStat
  
  after_create :enqueue
  
  protected
  
  def enqueue
    Rails.logger.info("  Queue: Enqueueing Sitemap generation")
    SitemapQueue.perform_at(self.enqueue_at)
  end

end