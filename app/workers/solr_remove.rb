require 'resque-history'

class SolrRemove
  extend Resque::Plugins::History
  @queue = :solr_remove

  def self.perform(classname, id)
    Rails.logger.info("  Resque: Removing from SOLR #{classname}: #{id}")
    Sunspot.remove_by_id(classname, id)
  end
end