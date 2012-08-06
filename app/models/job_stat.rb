class JobStat < ActiveRecord::Base
  
  belongs_to :processable, polymorphic: true
  
  after_create :enqueue
  
  protected
  
  def enqueue
    Rails.logger.info("  Queue: Enqueueing Sitemap generation")
    SitemapQueue.perform_at(self.enqueue_at)
  end

end
