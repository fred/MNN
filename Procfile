web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: QUEUE=* bundle exec rake environment resque:work
