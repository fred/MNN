class TwitterShare < Share
  belongs_to :item
  after_create :enqueue
  
  protected
  
  def enqueue
    TwitterQueue.perform(self.id)
  end
  
end
