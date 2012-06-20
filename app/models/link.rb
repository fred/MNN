class Link < ActiveRecord::Base

  # Validations
  validates_presence_of   :title
  validates_presence_of   :url
  validates_presence_of   :priority
  validates_uniqueness_of :url

end
