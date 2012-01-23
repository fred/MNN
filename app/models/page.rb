class Page < ActiveRecord::Base
  
  attr_accessor :updated_reason
  
  # Versioning System
  has_paper_trail :meta => { :tag  => :updated_reason }
  
  # Permalink URLS
  extend FriendlyId
  friendly_id :title, :use => :slugged
  
  
end
