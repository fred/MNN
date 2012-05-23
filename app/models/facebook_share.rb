class FacebookShare < Share
  belongs_to :item
  after_create :enqueue
  
  protected
  
  def enqueue
    if Rails.env.production?
      FacebookQueue.perform_async(self.id)
    else
      Rails.logger.info("  Queue: Updating Facebook status: #{self.id}")
    end
  end
  
end
