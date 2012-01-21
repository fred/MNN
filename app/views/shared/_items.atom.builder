atom_feed({ 'xmlns' => "http://www.w3.org/2005/Atom",
'xmlns:app' => 'http://www.w3.org/2007/app', 
'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |xml|
  
  # if @rss_source
  #   xml.id(@rss_source)
  # else
  #   xml.id(request.url)
  # end
  xml.link(@rss_source) if @rss_source
  xml.title(@rss_title) if @rss_title
  xml.description(@rss_description) if @rss_description
  xml.updated(@last_published.utc) if @last_published
  xml.language(@rss_language) if @rss_language
  xml.generator("Ruby on Rails")
  xml.category(@rss_category) if @rss_category
  xml.rights("OpenSource News, free to redistribute")
  
  
  for item in @items
    xml.entry(item) do
      xml.id(item.id)
      xml.title(item.title)
      xml.category(item.category_title)
      xml.summary(item.abstract)

      # xml.content(atom_description(item))
      xml.content "type" => "html" do
        xml.text! render(:partial => "/shared/atom_item", :locals => {:item => item})
      end

      xml.author do |author|
        author.name(item.user_title)
        author.email(item.user_email)
        author.uri(url_for(author_path(item.user, :only_path => false, :protocol => 'http')))
      end
      xml.source do |source|
        source.id(item.source_url)
        source.name(item.author_name)
        source.updated(item.updated_at.utc)
      end
      xml.published(item.published_at.utc)
      xml.updated(item.updated_at.utc)
      xml.link(url_for(item_path(item, :only_path => false, :protocol => 'http')))
    end
  end

end
