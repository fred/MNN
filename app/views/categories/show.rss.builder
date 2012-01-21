xml.instruct! :xml, :version=>"1.0"
xml.instruct! 'xml-stylesheet', {:href => asset_path('rss.css'), :type => 'text/css'}

xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title(@rss_title) if @rss_title
    xml.description(@rss_description) if @rss_description
    xml.language(@rss_language) if @rss_language
    xml.generator("Ruby on Rails")
    xml.managingEditor("inbox@mnn.herokuapp.com")
    xml.webMaster("admin@mnn.herokuapp.com")
    xml.copyright("Opensource News, free to copy and redistribute.")
    if @rss_source
      xml.source(@rss_source)
    else
      xml.source(request.url)
    end
    xml.lastBuildDate(@last_published.strftime("%a, %d %b %Y %H:%M:%S %z")) if @last_published
    xml.pubDate(@last_published.strftime("%a, %d %b %Y %H:%M:%S %z")) if @last_published
    xml.category(@rss_category) if @rss_category
    xml.ttl(60) # 60 minutes
    for item in @items
      xml.item do
        xml.title(item.title)
        if @rss_source
          xml.source(@rss_source)
        else
          xml.source(request.url)
        end
        xml.guid(item.id)
        xml.category(item.category_title)
        xml.description(rss_description(item))
        xml.author("#{item.user_title} #{item.user_email}")
        xml.pubDate(item.published_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.published(item.published_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.updated(item.published_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(url_for(item_path(item, :only_path => false, :protocol => 'http')))
      end
    end
  }
}