class Category < ActiveRecord::Base
  
  # Versioning System
  has_paper_trail
  
  validates_presence_of :title
  validates_uniqueness_of :title
end
