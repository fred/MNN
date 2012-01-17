require 'resque/server'

if Rails.env.production?
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  AUTH_PASSWORD = "welcomez" || ENV['AUTH']
  if AUTH_PASSWORD
    Resque::Server.use Rack::Auth::Basic do |username, password|
      password == AUTH_PASSWORD
    end
  end
else
  Resque.redis = Redis.new(:host => "127.0.0.1", :port => 6379)
end