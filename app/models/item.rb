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
  has_many :attachments, :as => :attachable
  has_many :item_stats
  has_and_belongs_to_many :tags, :join_table => "taggings", 
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"
  has_and_belongs_to_many :region_tags, :join_table => "taggings",
    :foreign_key => "taggable_id", :association_foreign_key => "tag_id"
    
  # Nested Attributes
  accepts_nested_attributes_for :attachments, :allow_destroy => true
  
  
  def admin_permalink
    admin_item_path(self)
  end
end
