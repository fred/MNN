class SolrRemove
  @queue = :solr_remove

  def self.perform(classname, id)
    classname.constantize.find(id).solr_remove_from_index
  end
end