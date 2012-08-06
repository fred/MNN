#web: bundle exec unicorn_rails -c config/unicorn.dev.rb -E development
web: puma -C config/puma.rb
worker: bundle exec sidekiq -c 4 -e development
