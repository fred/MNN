Twitter.configure do |config|
  config.consumer_key = ENV["TWITTER_CONSUMER_KEY"].to_s
  config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"].to_s
  config.oauth_token = ENV["TWITTER_OAUTH_TOKEN"].to_s
  config.oauth_token_secret = ENV["TWITTER_OAUTH_TOKEN_SECRET"].to_s
end