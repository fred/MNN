class Category < ActiveRecord::Base
  
  # Versioning System
  has_paper_trail
  
  # Validations
  validates_presence_of :title
  validates_uniqueness_of :title
  
  # Relationships
  has_many :items
  
end
