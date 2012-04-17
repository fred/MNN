require 'resque/server'
require 'resque-history/server'

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Resque.redis = Redis.new(:host => "127.0.0.1", :port => 6379)
end

RESQUE_USERNAME = "welcomez" || ENV['RESQUE_USERNAME']
RESQUE_PASSWORD = "welcomez" || ENV['RESQUE_PASSWORD']

Resque::Server.use Rack::Auth::Basic, "Resque-WorldMathaba" do |username, password|
  [username, password] == [RESQUE_USERNAME, RESQUE_PASSWORD]
end

# Resque::Plugins::History::MAX_HISTORY_SIZE = 100
