class FacebookShare < Share
  belongs_to :item
  after_create :enqueue
  
  protected
  
  def enqueue
    if Rails.env.production?
      Resque.enqueue(FacebookQueue,self.id)
    else
      Rails.logger.info("  Resque: Updating Facebook status: #{self.id}")
    end
  end
  
end
