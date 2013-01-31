require './lib/scheduler.rb'

REDIS_NAMESPACE = OpenSSL::HMAC.hexdigest('md5', Rails.application.class.parent_name, Rails.env)[0..15]

# By default, sidekiq assumes Redis is at localhost:6379. 
# This is fine for development but for many deployments you'll need to point sidekiq to an external 
# Redis server and an optional namespace by throwing this in config/initializers/sidekiq.rb

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://127.0.0.1:6379', namespace: REDIS_NAMESPACE }
  # Publication::FeedScheduler.new.run! if Rails.env.production?
end
# Next, you need to configure the Sidekiq client, which is similar.
# If you're using the client with a single-threaded Rails (or other ruby) process,
# add a size of 1, which will provide one Redis connection for the client:

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://127.0.0.1:6379', namespace: REDIS_NAMESPACE }
end
