class TwitterShare < Share
  belongs_to :item
  after_create :enqueue
  
  protected
  
  def enqueue
    if Rails.env.production?
      # TwitterQueue.perform(self.id)
      if self.enqueue_at.to_i < Time.now.to_i
        time = Time.now+60
      else
        time = self.enqueue_at
      end
      Resque.enqueue_at(time,TwitterQueue,self.id)
    else
      Rails.logger.info("  Resque: Updating twitter status: #{self.id}")
    end
  end
  
end
