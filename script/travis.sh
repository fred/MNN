gem install bundler

if ([ "$TRAVIS_RUBY_VERSION" == "jruby" ]); then
  echo "on jruby, setting up Gemfile.lock"
  rm -rf Gemfile.lock
  cp Gemfile.lock.jruby Gemfile.lock
fi

bundle install --without development production assets

echo "Setting up database.yml"
cp config/database.yml.travis config/database.yml
cp config/sunspot.yml.sample config/sunspot.yml

echo "Creating databases and migrating it"
psql -c 'create database mnn_test;' -U postgres
bundle exec rake db:create --trace
bundle exec rake db:migrate --trace
