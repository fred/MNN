Twitter.configure do |config|
  config.consumer_key = ENV["TWITTER_CONSUMER_KEY"].to_s
  config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"].to_s
end