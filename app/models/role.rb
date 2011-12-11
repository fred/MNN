class Role < ActiveRecord::Base
  
  # Versioning System
  has_paper_trail
  
  validates_presence_of :title
  validates_uniqueness_of :title
  
  has_and_belongs_to_many :users
end
