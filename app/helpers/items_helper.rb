module ItemsHelper
  
  def item_title(item)
    str = ""
    str += "#{image_tag(item.main_image.image.thumb, :class => "tooltip_image")}" if item.has_image?
    str += "<strong>#{item.title}</strong>"
    str += "<br/>"
    str += "#{item.abstract}"
    str
  end
  
  def twitter_link
    "https://twitter.com/#/worldmathaba"
  end
  
  def rss_description(item)
    html = ""
    if item.has_image?
      html += "<div class='image'>"
      html += image_tag(item.main_image.image.small)
      html += "</div>"
    end
    html += "<div class='abstract'>"
    html += item.abstract
    html += "</div>"
  end
  
  def meta_title(item)
    str = item.title
    return str
  end
  def meta_description(item)
    str = item.abstract
    return str
  end
  
  def linkedin_share(item)
    # Example:
    # http://www.linkedin.com/shareArticle?mini=true&url=CONTENT-URL&title=CONTENT-TITLE&summary=DEATILS-OPTIONAL&source=YOURWEBSITE-NAME
    url = "http://www.linkedin.com/shareArticle?mini=true&url="
    url += url_for(item_path(item.id, :only_path => false, :protocol => 'https'))
    url += "&title=#{item.title}"
    url += "&source=MNN"
    return url
  end
  
  def facebook_share(item)
    url = "https://www.facebook.com/sharer.php?u="
    url += url_for(item_path(item.id, :only_path => false, :protocol => 'https'))
    url += "&t=#{meta_title(item)}"
    return url
  end
  
  def twitter_share(item)
    url = "https://twitter.com/home?status="
    url += item.title.truncate(116)
    url += " "
    url += url_for(item_path(item, :only_path => false, :protocol => 'https'))
    return url
  end
  
  def digg_share(item)
    url = "http://digg.com/submit?url="
    url += url_for(item_path(item, :only_path => false, :protocol => 'https'))
    url += "&title="
    url += item.title
    return url
  end
  
  def gplus_share(item)
    url = "https://plusone.google.com/_/+1/confirm?hl=en&url="
    url += url_for(item_path(item, :only_path => false, :protocol => 'https'))
    return url
  end
    
  def reddit_share(item)
    url = "http://www.reddit.com/submit?url="
    url += url_for(item_path(item, :only_path => false, :protocol => 'https'))
    url += "&title="
    url += item.title
    return url
  end
  
  def posterous_share(item)
    url = "http://posterous.com/share?linkto="
    url += url_for(item_path(item, :only_path => false, :protocol => 'https'))
    return url
  end
  
  def slashdot_share(item)
    url = "http://slashdot.org/slashdot-it.pl?op=basic&url="
    url += url_for(item_path(item, :only_path => false, :protocol => 'https'))
    url += "&title="
    url += item.title
    return url
  end
  
  def delicious_share(item)
    url = "http://www.delicious.com/save?url="
    url += url_for(item_path(item, :only_path => false, :protocol => 'https'))
    url += "&title="
    url += item.title
    url += "&notes="
    url += item.abstract
    return url
  end
  
  def email_share(item)
    sbj = item.title
    body = "#{item.abstract} - "
    body += url_for(item_path(item, :only_path => false, :protocol => 'https'))
    "mailto:?subject=#{sbj}&body=#{body}"
  end
  
end
