require 'resque-history'

class CommentNotification
  extend Resque::Plugins::History
  @queue = :comment_notification
  @max_history = 200
  
  def self.perform(comment_id)
    Rails.logger.info("  Resque: Delivering emails for Comment: #{comment_id}")
    CommentsNotifier.new_comment(comment_id).deliver
    Rails.logger.info("  Resque: Done delivering emails for Comment: #{comment_id}")
  end
end
