web: bundle exec thin start -p $PORT -e $RACK_ENV
worker: QUEUE=* exec bundle exec rake resque:work
