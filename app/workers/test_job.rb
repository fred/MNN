class TestJob < BaseWorker

  def perform
    Rails.logger.info("  Queue: doing TEST job, sleep 10 seconds")
    sleep 10
  end
end
