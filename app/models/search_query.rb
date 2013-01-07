class SearchQuery < Query

  def self.popular(lang='en')
    select("keyword, locale, count(keyword)").
    where(locale: lang.to_s).
    group("keyword,locale").
    order("count DESC")
  end

end
