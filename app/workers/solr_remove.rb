class SolrRemove < BaseWorker
  sidekiq_options :queue => :solr_remove
  def perform(classname, id)
    Rails.logger.info("  Queue: Removing from SOLR #{classname}: #{id}")
    Sunspot.remove_by_id(classname, id)
  end
end