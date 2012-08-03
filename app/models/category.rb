class Category < ActiveRecord::Base
  
  # Versioning System
  has_paper_trail
  
  # Validations
  validates_presence_of :title
  validates_presence_of :description
  validates_uniqueness_of :title
  
  # Relationships
  has_many :items

  has_one :last_item,
    class_name: "Item",
    order: "items.published_at DESC",
    conditions: proc { ["(items.draft = ?) AND (published_at is not NULL) AND (published_at < ?)", false, Time.now.to_s(:db)] }
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  def published_items
    self.
      items.
      includes(:attachments).
      where(draft: false).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC")
  end
  
  def top_items(lmt=8)
    self.
      items.
      includes(:attachments).
      localized.
      where(draft: false).
      where("published_at is not NULL").
      where("published_at < '#{Time.now.to_s(:db)}'").
      order("published_at DESC").
      limit(lmt)
  end
  
  def last_item
    self.
      items.
      where(draft: false).
      where("published_at is not NULL").
      where("published_at < ?", DateTime.now).
      order("published_at DESC").
      first
  end

  def item_last_update
    t = self.last_item
    if t
      t.updated_at
    else
      Time.now
    end
  end
  
end
