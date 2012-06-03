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
  xml.generator("WorldMathaba")
  xml.rights("Please see our copyrights page.")
  for comment in @comments
    xml.entry(comment) do
      xml.title("#{comment.display_name.capitalize} comment")
      xml.content "type" => "html" do
        xml.text! render(partial: "opinio/comments/comment", locals: {comment: comment}, formats: 'html')
      end
      xml.author {
        xml.name comment.display_name
        xml.uri(url_for(author_path(comment.owner, only_path: false, protocol: 'http')))
      }
    end
  end
end