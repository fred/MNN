require 'resque-history'

class SolrUpdate
  extend Resque::Plugins::History
  @queue = :solr_update

  def self.perform(classname, id)
    Rails.logger.info("  Resque: Indexing to SOLR item: #{id}")
    classname.constantize.find(id).solr_index
  end
end
