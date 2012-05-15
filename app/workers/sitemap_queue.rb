require 'resque-history'

class SitemapQueue
  extend Resque::Plugins::History
  @queue = :sitemaps
  @max_history = 50
  
  def self.perform
    Rails.logger.info("  Resque: Starting Sitemap Generation")
    require File.join(Rails.root,'config','sitemap.rb')
    Rails.logger.info("  Resque: Finished Sitemap Generation")
  end
end
