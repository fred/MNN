# web: bundle exec thin start -p $PORT -e $RACK_ENV
web: bundle exec unicorn_rails -c config/unicorn.dev.rb -E development
worker: bundle exec rake resque:work QUEUE=*
