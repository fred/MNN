module CommentHelper

  def is_subscribed?(item_id)
    current_user && current_user.comment_subscriptions.where(item_id: item_id).any?
  end

  def can_edit_comment(comment)
    if (current_user && (comment.owner == current_user)) \
      or (current_admin_user && (comment.owner == current_admin_user))
      true
    else
      false
    end
  end

end