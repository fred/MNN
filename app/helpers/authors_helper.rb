module AuthorsHelper

  def mini_user(user)
    str = ""
    str += link_to(
        image_tag(user.main_image, class: "item-image", title: user.title, alt: user.title),
        author_path(user),
        title: user.title
    )
    str += "<span class='item-title'>#{link_to user.title, author_path(user), title: user.title}</span>"
    str += "<span class='item-date'>Submitted #{user.items_count} Articles</span>"
    str
  end

end
