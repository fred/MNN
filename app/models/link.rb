class Link < ActiveRecord::Base
  has_paper_trail

  # Validations
  validates_presence_of   :title
  validates_presence_of   :url
  validates_presence_of   :priority
  validates_uniqueness_of :url

  def link_title
    tmp = []
    tmp << title if title.present?
    tmp << description if description.present?
    tmp.join(" - ")
  end

end
