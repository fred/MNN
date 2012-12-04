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

  def comment_rate(comment)
    score = comment.votes_for - comment.votes_against
    if score > 0
      " <span class='vote-score positive-vote'>(+#{score})</span>"
    elsif score < 0
      " <span class='vote-score negative-vote'>(#{score})</span>"
    else
      ""
    end
  end


end