class CommentNotification < BaseWorker
  sidekiq_options :queue => :comments
  def perform(comment_id)
    Rails.logger.info("  Queue: Delivering emails for Comment: #{comment_id}")
    CommentsNotifier.delay.new_comment(comment_id)
    Rails.logger.info("  Queue: Done delivering emails for Comment: #{comment_id}")
  end
end
