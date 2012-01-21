xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0", 'xmlns:atom' =>"http://www.w3.org/2005/Atom"){
  
  xml.channel{
    xml.tag! 'atom:link', :rel => 'self', :type => 'application/rss+xml', :href => request.url
    xml.title(@rss_title) if @rss_title
    xml.description(@rss_description) if @rss_description
    xml.language(@rss_language) if @rss_language
    xml.generator("Ruby on Rails")
    xml.managingEditor("editor@mnn.herokuapp.com (Editor)")
    xml.webMaster("admin@mnn.herokuapp.com (Admin)")
    xml.copyright("Opensource News, free to copy and redistribute.")
    if @rss_source
      xml.link(@rss_source)
    else
      xml.link(request.url)
    end
    xml.lastBuildDate(@last_published.rfc2822) if @last_published
    xml.pubDate(@last_published.rfc2822) if @last_published
    xml.category(@rss_category) if @rss_category
    xml.ttl(60) # 60 minutes
    for item in @items
      xml.item do
        xml.title(item.title)
        xml.guid(url_for(item_path(item.id, :only_path => false, :protocol => 'http')))
        xml.category(item.category_title)
        xml.description(rss_description(item))
        xml.author("#{item.user_email} (#{item.user_title})")
        xml.pubDate(item.published_at.rfc2822)
        xml.link(url_for(item_path(item, :only_path => false, :protocol => 'http')))
      end
    end
  }
}