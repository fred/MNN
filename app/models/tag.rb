class Tag < ActiveRecord::Base
    
  validates_presence_of :title
  validates_uniqueness_of :title
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  has_and_belongs_to_many :items, :join_table => "taggings",
    :foreign_key => "tag_id", :association_foreign_key => "taggable_id"
  
  
end
