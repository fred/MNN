class Language < ActiveRecord::Base
  has_many :items
  # Permalink URLS
  extend FriendlyId
  friendly_id :description, use: :slugged
  
  validates_presence_of :locale, :description
  validates_uniqueness_of :locale
  
  def top_items(lmt=8)
    Item.published.not_draft.
      where(language_id: self.id).
      order("published_at DESC").
      includes(:attachments).
      limit(lmt)
  end
  
  def title
    self.description
  end
  
  # only give languages with more than 1 item
  def self.with_articles
    find(:all, order: 'languages.locale DESC')
    # find(:all,
    #   select: '"languages".id, "languages".description, "languages".slug, count("items".id) as counter', 
    #   joins: :items,
    #   group: '"languages".id',
    #   order: 'languages.locale DESC'
    # )
  end

  def item_last_update
    if !self.items.empty? && self.items.last_item
      self.items.last_item.updated_at
    else
      Time.now
    end
  end
end
