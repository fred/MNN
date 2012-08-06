class Language < ActiveRecord::Base
  DEFAULT_LOCALE = 'en'

  has_many :items, inverse_of: :language

  # Permalink URLS
  extend FriendlyId
  friendly_id :description, use: :slugged
  
  validates_presence_of :locale, :description
  validates_uniqueness_of :locale
  
  def top_items(lmt=8)
    Item.published.not_draft.
      where(language_id: self.id).
      order("published_at DESC").
      includes(:attachments, :language).
      limit(lmt)
  end

  def base_domain
    if Rails.env.production?
      "worldmathaba.net"
    else
      "mathaba.dev"
    end
  end

  def localized_domain
    if locale.match(DEFAULT_LOCALE)
      base_domain
    else
      "#{locale}.#{base_domain}"
    end
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
    t = self.items.last_item
    if t
      t.updated_at
    else
      Time.now
    end
  end
end
