class TwitterShare < Share
  belongs_to :item
  after_create :enqueue
  
  protected
  
  def enqueue
    if Rails.env.production?
      if self.enqueue_at.to_i < Time.now.to_i
        time = Time.now+60
      else
        time = self.enqueue_at
      end
      TwitterQueue.perform_at(time,self.id)
    else
      Rails.logger.info("  Queue: [DEV] Updating twitter status: #{self.id}")
    end
  end
  
end
