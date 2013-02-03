class FacebookShare < Share
  belongs_to :item
  after_create :enqueue

  def status_link
    if self.status.present? && self.status.match("^[0-9]+_[0-9]+")
      status_id = self.status.to_s.split("_")[1]
      "#{Settings.facebook_link}/posts/#{status_id}"
    else
      nil
    end
  end

  def post(item)
    self.processed_at = Time.now
    user = User.find Settings.facebook_manager_id
    @user_graph = Koala::Facebook::API.new(user.oauth_token)
    @page_token = @user_graph.get_page_access_token(Settings.facebook_page_id)
    @page_graph = Koala::Facebook::API.new(@page_token)
    url = Rails.application.routes.url_helpers.item_path(item, only_path: false, host: Settings.host)
    if @page_graph
      res = @page_graph.put_wall_post(item.title, {name: item.title, link: url})
    end
    if res && res["id"]
      self.status = res["id"]
    else
      res = false
      self.status = 'FAILED'
    end
    self.processed_at = Time.now
    self.processed = true
    self.save
    res
  end
  
  protected
  
  def enqueue
    if Rails.env.production?
      if self.enqueue_at.to_i < Time.now.to_i
        time = Time.now+30
      else
        time = self.enqueue_at
      end
      FacebookQueue.perform_at(time,self.id)
    else
      Rails.logger.info("  Queue: Updating Facebook status: #{self.id}")
    end
  end
  
end
