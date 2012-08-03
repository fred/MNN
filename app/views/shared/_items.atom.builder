cache_expiring("atom/#{@etag}", 900) do
  atom_feed({ 
    'xmlns' => "http://www.w3.org/2005/Atom",
    'xmlns:app' => 'http://www.w3.org/2007/app',
    'xmlns:opensearch' => 'http://a9.com/-/spec/opensearch/1.1/'
  }) do |xml|

    xml.title(@rss_title) if @rss_title
    if @last_published
      xml.updated(@last_published.utc)
    else
      Time.now.utc
    end
    xml.generator("Ruby on Rails")
    xml.rights("Please see our copyrights page.")
    if params[:q] && @search && (@search.total > 0)
      xml.opensearch(:totalResults,@search.total)
      xml.opensearch(:startIndex,@items.current_page)
      xml.opensearch(:itemsPerPage,@items.per_page)
    end
    for item in @items
      xml.entry(item, published: item.published_at) do
        xml.title(item.title)
        xml.summary(item.abstract) unless item.abstract.to_s.empty?
        xml.content "type" => "html" do
          xml.text! render(partial: "/shared/atom_item", locals: {item: item})
        end
        if item.user
          xml.author {
            xml.name item.user_title
            xml.email item.user_email
            xml.uri(url_for(author_path(item.user, only_path: false, protocol: 'http')))
          }
        end
      end
    end
  end
end