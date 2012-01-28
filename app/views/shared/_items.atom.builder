atom_feed({ 'xmlns' => "http://www.w3.org/2005/Atom",
'xmlns:app' => 'http://www.w3.org/2007/app',
'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |xml|
  
  xml.title(@rss_title) if @rss_title
  xml.updated(@last_published.utc) if @last_published
  xml.generator("Ruby on Rails")
  xml.rights("Please see our copyrights page.")
  for item in @items
    xml.entry(item) do
      xml.title(item.title)
      xml.summary(item.abstract) unless item.abstract.to_s.empty?
      xml.content "type" => "html" do
        xml.text! render(:partial => "/shared/atom_item", :locals => {:item => item})
      end
      xml.author {
        xml.name item.user_title
        xml.email item.user_email
        xml.uri(url_for(author_path(item.user, :only_path => false, :protocol => 'https')))
      }
    end
  end
end
