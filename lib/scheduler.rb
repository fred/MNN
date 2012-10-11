#### Run a scheduler on another celluloid Thread
# https://gist.github.com/e637d1194c45716797c5

require 'celluloid'

module Publication
  class FeedScheduler
    include Celluloid

    # run every hour
    POLL_INTERVAL = 3600

    def run
      Rails.logger.info("[Celluloid] Starting FeedScheduler scheduler thread")
      # TODO: don't do anything if the feeder is trying to shutdown..
      loop do
        sleep 10
        Rails.logger.info("[Celluloid] Running FeedScheduler from scheduler thread")
        FeedSiteQueue.perform_async(nil)
        sleep POLL_INTERVAL-10
      end
    rescue => ex
      return if ex.is_a?(Celluloid::Task::TerminatedError)
      Rails.logger.error "[Celluloid] FeedScheduler failed! -- "+ex.message+"\n"+ex.backtrace.join("\n")
    end
  end
end
