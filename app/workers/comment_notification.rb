class CommentNotification < BaseWorker

  def perform(comment_id)
    Rails.logger.info("  Queue: Delivering emails for Comment: #{comment_id}")
    CommentsNotifier.new_comment(comment_id).deliver
    Rails.logger.info("  Queue: Done delivering emails for Comment: #{comment_id}")
  end
end
