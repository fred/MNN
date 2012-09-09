class FeedEntry < ActiveRecord::Base
  
  belongs_to :feed_site
  
  def self.default_per_box
    16
  end
  
  scope :per_box, :limit => default_per_box
  
  def set_read
    if self.unread?
      FeedEntry.update_all("unread = 0", [ "id = ?", self.id])
      # sql = "update feed_entries set unread = 0 where id = #{self.id};"
      # ActiveRecord::Migration.execute(sql)
    end
  end
  
end
