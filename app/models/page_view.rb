class PageView < Query

  belongs_to :item

  def self.recent_page_views(lim=10)
    order("id DESC").
    limit(lim)
  end

  def self.from_users
    where("user_id is not NULL")
  end

  def self.from_guests
    where("user_id is NULL")
  end

end
