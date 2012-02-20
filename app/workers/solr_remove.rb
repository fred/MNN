class SolrRemove
  @queue = :solr
  
  def self.perform(klass, id)
    Sunspot.remove_by_id(klass, id)
  end
  
end