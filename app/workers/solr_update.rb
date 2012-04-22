class SolrUpdate
  @queue = :solr_update

  def self.perform(classname, id)
    classname.constantize.find(id).solr_index
  end
end
