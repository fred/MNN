#!/bin/sh

set +e

solr_responding() {
  port=$1
  curl -o /dev/null "http://localhost:$port/solr/admin/ping" > /dev/null 2>&1
}

wait_until_solr_responds() {
  port=$1
  while ! solr_responding $1; do
    /bin/echo -n "."
    sleep 1
  done
}

gem install bundler

if ([ "$TRAVIS_RUBY_VERSION" == "jruby" ]); then
  echo "on jruby, setting up Gemfile.lock"
  rm -rf Gemfile.lock
  cp Gemfile.lock.jruby Gemfile.lock
fi

bundle install --without none

echo "Setting up database.yml"
cp config/database.yml.travis config/database.yml
cp config/sunspot.yml.sample config/sunspot.yml

bundle exec sunspot-solr start -p 8983
wait_until_solr_responds 8983
/bin/echo "Solr is ready"

echo "Creating databases and migrating it"
psql -c 'create database mnn_test;' -U postgres
bundle exec rake db:create --trace
bundle exec rake db:migrate --trace
