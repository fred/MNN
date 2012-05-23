web: bundle exec unicorn_rails -c config/unicorn.dev.rb -E development
worker: bundle exec sidekiq-scheduler -c 10 -P ./tmp/pids/resque-worker.pid