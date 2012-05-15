class Tag < ActiveRecord::Base
    
  validates_presence_of :title
  validates_uniqueness_of :title
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_and_belongs_to_many :items, join_table: "taggings",
    foreign_key: "tag_id", association_foreign_key: "taggable_id"
  
	def item_last_update
		if !self.items.empty? && self.items.last_item
			self.items.last_item.updated_at
		else
			Time.now
		end
	end

end
