module ItemsHelper

  def alt_for_image(image)
    if !image.title.to_s.empty?
      image.title
    elsif image.attachable
      image.attachable.title
    else
      image.image
    end
  end

  def item_popover(item)
    title_str = ""
    if item.has_image?
      title_str += image_tag(item.main_image.image.thumb, class: "tooltip_image", title: item.main_image.title, alt: item.main_image.title)
    end
    title_str += item.title.to_s
    title_str += "<br/>"
    title_str += "#{item.abstract}"
    title_str += "<br/>"
    content_str = "<span class='date_small'> #{time_ago_in_words(item.published_at)} ago - by #{item.author_name}</span>"
    return {:title => title_str, 'data-content' => content_str, id: 'popover', rel: 'popover'}
  end

  def item_title_small(item)
    str = ""
    str += "#{item.title}<br/>#{item.abstract}"
    str += "<br/>"
    str += "<div class='icon-time date_small'> #{time_ago_in_words(item.published_at)} ago - by #{item.author_name}</div>"
  end

  def item_mini(item)
    str = ""
    if item.has_image?
      str += link_to(
          image_tag(item.main_image.image.thumb, class: "item-image", title: item.abstract, alt: item.main_image.title),
          item,
          title: item.abstract,
          id: 'tooltip'
      )
    elsif item.youtube_id
      str += link_to(
          image_tag(youtube_thumb(item), class: "item-image", title: item.abstract),
          item,
          title: item.abstract,
          id: 'tooltip'
      )
    end
    str += "<span class='item-title'> #{link_to item.title.truncate(55), item, title: item.abstract, id: 'tooltip'}</span>"
    if item.item_stat
      str += "<span class='item-views'> Viewed #{item.item_stat.views_counter} times</span>"
    end
    str += "<span class='icon-time item-date'> Published #{time_ago_in_words(item.published_at)} ago</span>"
    str
  end

  def item_title(item)
    str = ""
    if item.has_image?
      str += image_tag(item.main_image.image.thumb, class: "tooltip_image", title: item.main_image.title, alt: item.main_image.title)
    end
    str += "#{item.title}"
    str += "<br/>"
    str += "#{item.abstract}"
    str += "<br/>"
    str += "<div class='date_small'>#{time_ago_in_words(item.published_at)} ago - by #{item.author_name}</div>"
    str
  end

  def youtube_thumb(item,n=2)
    "https://img.youtube.com/vi/#{item.youtube_id}/#{n}.jpg"
  end

  def twitter_link
    "https://twitter.com/#/worldmathaba"
  end

  def rss_description(item)
    html = ""
    if item.has_image?
      html += "<div class='image'>"
      html += image_tag(item.main_image.image.small, alt: item.main_image.title)
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
    url = "http://www.linkedin.com/shareArticle?mini=true&url="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&title=#{url_encode(item.title)}"
    url += "&source=MNN"
    return url
  end

  def facebook_share(item)
    url = "https://www.facebook.com/sharer.php?u="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&t=#{url_encode(meta_title(item))}"
    return url
  end

  def twitter_share(item)
    url = "https://twitter.com/home?status="
    url += url_encode(item.title.truncate(116))
    url += "%20"
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    return url
  end

  def digg_share(item)
    url = "http://digg.com/submit?url="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&title="
    url += url_encode(item.title)
    return url
  end

  def gplus_share(item)
    url = "https://plusone.google.com/_/+1/confirm?hl=en&url="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    return url
  end

  def reddit_share(item)
    url = "http://www.reddit.com/submit?url="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&title="
    url += url_encode(item.title)
    return url
  end

  def posterous_share(item)
    url = "http://posterous.com/share?linkto="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&title="
    url += url_encode(item.title)
    return url
  end

  def slashdot_share(item)
    url = "http://slashdot.org/slashdot-it.pl?op=basic&url="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&title="
    url += url_encode(item.title)
    return url
  end

  def delicious_share(item)
    url = "http://www.delicious.com/save?url="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&title="
    url += url_encode(item.title)
    url += "&notes="
    url += url_encode(item.abstract)
    return url
  end

  def email_share(item)
    sbj = item.title
    body = "#{item.abstract} - "
    body += url_for(item_path(item, only_path: false, protocol: 'http'))
    "mailto:?subject=#{url_encode(sbj)}&body=#{url_encode(body)}"
  end

  def diaspora_share(item)
    url = "http://sharetodiaspora.github.com/?url="
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&title="
    url += url_encode(item.title)
    return url
  end

end
