require 'resque/server'

AUTH_PASSWORD = "welcomez" || ENV['AUTH']

if AUTH_PASSWORD
  Resque::Server.use Rack::Auth::Basic do |username, password|
    password == AUTH_PASSWORD
  end
end