# web: bundle exec thin start -p $PORT -e $RACK_ENV
web: bundle exec unicorn_rails -c config/unicorn.dev.rb -E development
worker: bundle exec rake environment resque:work QUEUE=* VERBOSE=1
scheduler: bundle exec rake environment resque:scheduler VERBOSE=1