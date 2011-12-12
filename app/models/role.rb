class Role < ActiveRecord::Base
  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models
    
  # Versioning System
  has_paper_trail
  
  validates_presence_of :title
  validates_uniqueness_of :title
  
  has_and_belongs_to_many :users
  
  def admin_permalink
    admin_role_path(self)
  end
end
