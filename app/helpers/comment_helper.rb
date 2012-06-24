module CommentHelper

  def can_edit_comment(comment)
    if (current_user && (comment.owner == current_user)) \
      or (current_admin_user && (comment.owner == current_admin_user))
      true
    else
      false
    end
  end


end