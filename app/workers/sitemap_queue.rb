class SitemapQueue < BaseWorker
  sidekiq_options :queue => :sitemap
  def perform
    Rails.logger.info("  Queue: Starting Sitemap Generation")
    require File.join(Rails.root,'config','sitemap.rb') if Rails.env.production?
    Rails.logger.info("  Queue: Finished Sitemap Generation")
  end
end
