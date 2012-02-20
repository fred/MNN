require 'resque/server'

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Resque.redis = Redis.new(:host => "127.0.0.1", :port => 6379)
end

RESQUE_USERNAME = "admin" || ENV['RESQUE_USERNAME']
RESQUE_PASSWORD = "welcomez" || ENV['RESQUE_PASSWORD']
Resque::Server.use Rack::Auth::Basic do |username, password|
  username = RESQUE_USERNAME
  password = RESQUE_PASSWORD
end
