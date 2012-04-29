xml.instruct!
xml.OpenSearchDescription(:xmlns => 'http://a9.com/-/spec/opensearch/1.1/', 'xmlns:moz' => 'http://www.mozilla.org/2006/browser/search/') do
  xml.ShortName(t(:default_title))
  xml.InputEncoding('UTF-8')
  xml.Description(t(:opensearch_description))
  xml.Contact(t(:contact_email))
  xml.Image(full_image_path_helper('icon.png'), height: 16, width: 16, type: 'image/png')
  # escape route helper or else it escapes the '{' '}' characters. then search doesn't work
  xml.Url(type: 'text/html', method: 'get', template: CGI::unescape(search_url(q: '{searchTerms}' )))
  xml.moz(:SearchForm, root_url)
end