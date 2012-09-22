class FacebookShare < Share
  belongs_to :item
  after_create :enqueue


  def post(item)
    share.processed_at = Time.now
    user = User.find Settings.facebook_manager_id
    @graph = Koala::Facebook::API.new(user.oauth_token)
    @page_token = @graph.get_page_access_token(Settings.facebook_page_id)
    @page_graph = Koala::Facebook::API.new(@page_token)
    url = url_helpers.item_path(item, only_path: false, host: Settings.host)
    if @page_graph
      res = @page_graph.put_wall_post(item.title, {name: item.title, link: url})
    end
    if res && res["id"]
      share.status = res["id"]
      share.save
    else
      res = false
      share.status = 'FAILED'
      share.save
    end
    res
  end
  
  protected
  
  def enqueue
    if Rails.env.production?
      FacebookQueue.perform_async(self.id)
    else
      Rails.logger.info("  Queue: Updating Facebook status: #{self.id}")
    end
  end
  
end
