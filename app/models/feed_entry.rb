class FeedEntry < ActiveRecord::Base
  
  belongs_to :feed_site
  
  def self.default_per_box
    16
  end

  def self.per_box
    limit(default_per_box)
  end
  
  def set_read
    if self.unread?
      FeedEntry.update_all("unread = 0", [ "id = ?", self.id])
    end
  end
  
end
