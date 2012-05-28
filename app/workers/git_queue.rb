class GitQueue < BaseWorker

  def perform(json_payload)
    Rails.logger.info("  Queue: Delivering emails for git push")
    GitMailer.push_received(json_payload).deliver
    Rails.logger.info("  Queue: Done delivering emails for git push")
  end
end