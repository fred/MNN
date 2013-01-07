class PageView < Query

  belongs_to :item

  def self.recent_page_views(lim=10)
    order("id DESC").
    limit(lim)
  end

end
