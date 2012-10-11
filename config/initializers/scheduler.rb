if Rails.env.production?
  require './lib/scheduler.rb'
  Publication::FeedScheduler.new.run!
end
