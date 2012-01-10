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
  
  # only give languages with more than 1 item
  def self.with_articles
    find(:all,
      :select => '"languages".id, "languages".description, "languages".slug, count("items".id) as counter', 
      :joins => :items,
      :group => '"languages".id',
      :order => 'languages.locale DESC'
    )
  end
end
