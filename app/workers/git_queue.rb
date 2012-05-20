require 'resque-history'

class GitQueue
  extend Resque::Plugins::History
  @queue = :git_hooks
  @max_history = 50
  
  def self.perform(json_payload)
    Rails.logger.info("  Resque: Delivering emails for git push")
    GitMailer.push_received(json_payload).deliver
    Rails.logger.info("  Resque: Done delivering emails for git push")
  end
end