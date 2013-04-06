module ItemsHelper

  def alt_for_image(image)
    if !image.title.blank?
      image.title
    elsif image.attachable
      image.attachable.title
    else
      image.image
    end
  end

  def item_title_small(item)
    str = ""
    str += "<div class='tooltip-title'> #{item.title} </div>"
    str += "<div class='tooltip-abstract'> #{item.abstract} </div>"
    str += "<div class='date_small'>"
    str += "<i class='icon-time'></i> "
    str += "#{time_ago_in_words(item.published_at)} #{_('ago')} - #{_('by')} #{item.author}"
    str += "</div>"
  end

  def item_mini_related(item)
    str = ""
    if item.has_image?
      str += link_to(
          image_tag(item.main_image.image.thumb, class: "item-image", title: item.abstract, alt: item.main_image.title),
          item,
          title: item.abstract,
          class: 'easy-tooltip'
      )
    elsif item.youtube_id
      str += link_to(
          image_tag(youtube_thumb(item), class: "item-image", title: item.abstract),
          item,
          title: item.abstract,
          class: 'easy-tooltip'
      )
    end
    str += "<div class='item-title'> "
    str += link_to(item.title, item, title: item.abstract, title: item_title(item), class: 'easy-tooltip')
    str += "</div>"
    str += "<div class='item-abstract'> "
    str += item.abstract
    str += "</div>"
    str
  end

  def item_mini(item)
    str = ""
    if item.has_image?
      str += link_to(
          image_tag(item.main_image.image.thumb, class: "item-image", title: item.abstract, alt: item.main_image.title),
          item,
          title: item.abstract,
          class: 'easy-tooltip'
      )
    elsif item.youtube_id
      str += link_to(
          image_tag(youtube_thumb(item), class: "item-image", title: item.abstract),
          item,
          title: item.abstract,
          class: 'easy-tooltip'
      )
    end
    str += "<span class='item-title'> "
    str += link_to(item.title.truncate(50), item, title: item.abstract, class: 'easy-tooltip')
    str += "</span>"
    if item.item_stat
      str += "<span class='item-views'>"
      str += (_("Viewed %{num} times") % { num: item.item_stat.views_counter }) if item.item_stat
      str += "</span>"
    end
    str += "<span class='item-date'>"
    str += "<i class='icon-time'></i> "
    str += _('Published') + " "
    str += time_ago_in_words(item.published_at) + " "
    str += _('ago')
    str += "</span>"
    str
  end

  def object_title(obj)
    if obj.is_a? Item
      item_title(obj)
    elsif obj.is_a? Comment
      comment_title(obj)
    else
      ""
    end
  end

  def comment_title(comment)
  end

  def item_title(item)
    str = ""
    if item.has_image?
      str += image_tag(item.main_image.image.small, class: "tooltip_image", title: item.main_image.title, alt: item.main_image.title)
    elsif item.youtube_id
      str += image_tag(youtube_thumb(item), class: "tooltip_image youtube_thumb", title: item.abstract, alt: item.youtube_id)
    end
    str += "<div class='tooltip-title'>#{item.title}</div>"
    str += "<div class='tooltip-abstract'>#{item.abstract}</div>"
    str += "<div class='date_small'> #{time_ago_in_words(item.published_at)} #{_('ago')} - #{_('by')} #{item.author}</div>"
    str
  end

  def youtube_thumb(item,n=2)
    "https://img.youtube.com/vi/#{item.youtube_id}/#{n}.jpg"
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

  def twitter_share_intent(item)
    url = "https://twitter.com/intent/tweet?"
    url += "text=#{url_encode(item.title.truncate(98))}"
    url += "%20"
    url += url_for(item_path(item, only_path: false, protocol: 'http'))
    url += "&via="
    url += "worldmathaba"
    url += "&related="
    url += "worldmathaba"
    if item.user && item.user.twitter.present?
      url += ",#{item.user.twitter_username}"
    end
    return url
  end

  def twitter_data_text(item)
    item.title.truncate(98)
  end
  
  def twitter_data_related(item)
    str = ['worldmathaba']
    str << item.user.twitter_username if item.user && item.user.twitter.present?
    str.join(',')
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
