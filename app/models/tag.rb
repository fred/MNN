class Tag < ActiveRecord::Base
  
  # Versioning System
  has_paper_trail
  
  validates_presence_of :title
  validates_uniqueness_of :title
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
end
