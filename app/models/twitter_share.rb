class TwitterShare < Share
  belongs_to :item
  after_create :enqueue
  
  protected
  
  def enqueue
    if Rails.env.production?
      # TwitterQueue.perform(self.id)
      Resque.enqueue(TwitterQueue,self.id)
    else
      Rails.logger.info("  Resque: Updating twitter status: #{self.id}")
    end
  end
  
end
