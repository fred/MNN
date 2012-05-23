# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://worldmathaba.net"
SitemapGenerator::Sitemap.create do
  add items_path, priority: 0.9, changefreq: 'hourly'
  Page.all.each do |page|
    add(page_path(page), lastmod: page.updated_at, priority: 0.5)
  end
  Category.all.each do |category|
    add(category_path(category), lastmod: category.item_last_update, priority: 0.8)
  end
  Tag.all.each do |tag|
    add(tag_path(tag), lastmod: tag.item_last_update, priority: 0.7)
  end
  Language.all.each do |lang|
    add(language_items_path(lang), lastmod: lang.item_last_update,priority: 0.7)
  end
  Item.for_sitemap.each do |item|
    add(item_path(item), changefreq: 'daily', priority: 0.6,
      news: {
        publication_name: "WorldMathaba",
        publication_language: item.language_title_short,
        title: item.title,
        keywords: item.tag_list,
        publication_date: item.published_at.xmlschema,
        genres: "PressRelease"
      }
    )
  end
end
SitemapGenerator::Sitemap.ping_search_engines