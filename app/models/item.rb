class Item < ActiveRecord::Base
  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models
  
  # Versioning System
  has_paper_trail
  
  # Comment System
  # opinio_subjectum
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  # Relationships
  belongs_to :user
  belongs_to :category
  
  has_many :attachments, :as => :attachable
  has_many :item_stats
  
  has_and_belongs_to_many :general_tags, :join_table => "taggings", 
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"
  has_and_belongs_to_many :region_tags, :join_table => "taggings",
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"
  has_and_belongs_to_many :country_tags, :join_table => "taggings",
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"
  # Nested Attributes
  accepts_nested_attributes_for :attachments, :allow_destroy => true
  
  
  def admin_permalink
    admin_item_path(self)
  end

  def published?
    !self.published_at.nil?
  end  
  
  def self.published
    where(:published_at => !nil)
  end
  def self.draft
    where(:draft => true)
  end
  
  # Returns the last 10 approved items (not draft anymore)
  def self.recent_updated(limit=10)
    published.
    where(:draft => false).
    order("updated_at DESC").
    limit(limit).
    all(:conditions => "updated_at > created_at")
  end
    
  # Returns the last 10 approved items (not draft anymore)
  def self.recent(limit=10)
    published.
    draft.
    order("id DESC").
    limit(limit).
    all
  end
  
  # Returns the last 10 draft items
  def self.recent_drafts(limit=10)
    draft.
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  # Returns the last 10 pending items (not draft anymore)
  def self.pending(limit=10)
    published.
    where(:draft => false).
    order("updated_at DESC").
    limit(limit).
    all
  end
  
  
  def category_title
    if self.category
      self.category.title
    else
      "Listing"
    end
  end
  
  
end