class ItemSweeper < ActionController::Caching::Sweeper
  observe Item # This sweeper is going to keep an eye on the Item model
 
  # If our sweeper detects that a Item was created call this
  def after_create(item)
    expire_index_cache
  end
 
  # If our sweeper detects that a Item was updated call this
  def after_update(item)
    expire_cache_for(item)
  end
 
  # If our sweeper detects that a Item was deleted call this
  def after_destroy(item)
    expire_cache_for(item)
  end
 
  private
  def expire_index_cache
    expire_fragment("views/items")
  end
  
  def expire_cache_for(item)
    # Expire the index page now that we added a new item
    # expire_page(:controller => 'items', :action => 'index')
    # Expire a fragment
    expire_fragment("item/#{item.id}")
    expire_fragment("shared/item/#{item.id}")
    expire_fragment("shared/item/#{item.id}/atom")
    expire_fragment("shared/item/#{item.id}/rss")
    # Rails.logger.debug("Going to sweep 'item/#{item.id}'")
  end
end