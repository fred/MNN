require 'resque-history'

module TestJob
  extend Resque::Plugins::History
  @queue = :test_queue
  @max_history = 100
  
  def self.perform()
    
    puts " *** RESQUE: doing test job, sleep 10 seconds"
    sleep 10
    ## Example of jobs to run here.
    # Stock.quote_all
  end
end
