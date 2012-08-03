class Tag < ActiveRecord::Base
    
  validates_presence_of :title
  validates_uniqueness_of :title
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_and_belongs_to_many :items, join_table: "taggings",
    foreign_key: "tag_id", association_foreign_key: "taggable_id",
    order: "published_at DESC"

  has_and_belongs_to_many :last_updated_items, join_table: "taggings",
    foreign_key: "tag_id", association_foreign_key: "taggable_id",
    order: "published_at DESC", limit: 1, class_name: "Item",
    conditions: "published_at is not NULL"
  
	def item_last_update
    t = self.last_updated_items.first
    if t
      t.updated_at
    else
      Time.now
    end
	end

end
