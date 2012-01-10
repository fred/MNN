class Language < ActiveRecord::Base
  has_many :items
  # Permalink URLS
  extend FriendlyId
  friendly_id :description, :use => :slugged
  
  def top_items(lmt=8)
    self.
      items.
      where(:draft => false).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      limit(lmt)
  end
end
