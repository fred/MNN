cache_expiring("rss/#{@etag}", 30.minutes) do
  xml.instruct! :xml, version: "1.0"
  xml.rss(
    version: "2.0", 
    'xmlns:atom' => "http://www.w3.org/2005/Atom", 
    'xmlns:opensearch' => "http://a9.com/-/spec/opensearch/1.1/"
  ){

    xml.channel{
      xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: request.url
      if @rss_title
        xml.title(@rss_title)
      else
        xml.title("WorldMathaba")
      end
      if @rss_description
        xml.description(@rss_description)
      else
        xml.description("WorldMathaba RSS")
      end
      xml.language(@rss_language) if @rss_language
      xml.generator("Ruby on Rails")
      xml.managingEditor("inbox@worldmathaba.net (Editor)")
      xml.webMaster("admin@worldmathaba.net (Admin)")
      xml.copyright("Please see our copyrights page.")
      if @rss_source
        xml.link(@rss_source)
      else
        xml.link(request.url)
      end
      xml.lastBuildDate(@last_published.rfc2822) if @last_published
      xml.pubDate(@last_published.rfc2822) if @last_published
      xml.category(@rss_category) if @rss_category
      xml.ttl(30) # in minutes, 1 hour

      if params[:q] && @search && (@search.total > 0)
        xml.opensearch(:totalResults,@search.total)
        xml.opensearch(:startIndex,@items.current_page)
        xml.opensearch(:itemsPerPage,@items.per_page)
      end

      for item in @items
        xml.item do
          xml.title(item.title)
          xml.guid(url_for(item_path(item, only_path: false, protocol: 'http')))
          xml.category(item.category_title)
          xml.description(rss_description(item))
          xml.pubDate(item.published_at.rfc2822)
          xml.link(url_for(item_path(item, only_path: false, protocol: 'http')))
        end
      end
    }
  }
end