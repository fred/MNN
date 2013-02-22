module AuthorsHelper

  def mini_user(user)
    count = user.items_count
    str = ""
    str += link_to(
        image_tag(user.main_image(:thumb), class: "item-image", title: user.title, alt: user.title),
        author_path(user),
        title: user.title
    )
    str += "<span class='item-title'>#{link_to user.title, author_path(user), title: user.title}</span>"
    str += "<span class='item-date'>Submitted #{pluralize(count,'Article')}</span>"
    str
  end

end
