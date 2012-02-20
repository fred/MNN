class SolrUpdate
  @queue = :solr
  
  def self.perform(klass, id)
    klass.find(id).solr_index
  end
  
end
