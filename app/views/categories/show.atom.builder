atom_feed({ 'xmlns' => "http://www.w3.org/2005/Atom",
'xmlns:app' => 'http://www.w3.org/2007/app', 
'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |feed|
  
  if @rss_source
    feed.id(@rss_source)
  else
    feed.id(request.url)
  end
  feed.link(@rss_source) if @rss_source
  feed.title(@rss_title) if @rss_title
  feed.description(@rss_description) if @rss_description
  feed.updated(@last_published.utc) if @last_published
  feed.language(@rss_language) if @rss_language
  feed.generator("Ruby on Rails")
  feed.category(@rss_category) if @rss_category
  feed.rights("OpenSource News, free to redistribute")
  
  
  for item in @items
    feed.item do
      feed.id(item.id)
      feed.title(item.title)
      feed.category(item.category_title)
      feed.summary(item.abstract)
      # feed.content(atom_description(item))
      # feed.author(item.user_title)
      feed.author do |author|
        author.name(item.user_title)
        author.email(item.user_email)
        author.uri(url_for(author_path(item.user, :only_path => false, :protocol => 'http')))
      end
      feed.source do |source|
        source.id(item.source_url)
        source.name(item.author_name)
        source.updated(item.updated_at.utc)
      end
      feed.published(item.published_at.utc)
      feed.updated(item.updated_at.utc)
      feed.link(url_for(item_path(item, :only_path => false, :protocol => 'http')))
    end
  end

end
