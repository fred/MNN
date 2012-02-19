require 'resque/server'

if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Resque.redis = Redis.new(:host => "127.0.0.1", :port => 6379)
end

AUTH_PASSWORD = "welcomez" || ENV['AUTH']
Resque::Server.use Rack::Auth::Basic do |username, password|
  password == AUTH_PASSWORD
end
