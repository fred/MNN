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

    for comment in @comments
      xml.item do
        xml.title("#{comment.display_name} said:")
        xml.description(
          sanitize(comment.body,
            tags: %w(p b i u a br em blockquote strong div ul ol li),
            attributes: %w(href)
          )
        )
        if @item
          xml.guid(url_for(item_comments_path(@item.id, only_path: false, protocol: 'http')))
          xml.pubDate(@item.last_commented_at.rfc2822) if @item.last_commented_at
          xml.link(url_for(item_comments_path(@item, only_path: false, protocol: 'http')))
        end
      end
    end
  }
}
