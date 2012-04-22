require 'resque-history'

class SolrRemove
  extend Resque::Plugins::History
  @queue = :solr_remove

  def self.perform(classname, id)
    Rails.logger.info("  Resque: Removing from SOLR item: #{id}")
    classname.constantize.find(id).solr_remove_from_index
  end
end