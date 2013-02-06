source 'http://rubygems.org'

### Basic
gem 'rack', '~> 1.4.3'
gem 'rack-cache'
gem 'rake'
# gem 'rails', '3.2.11'
gem 'rails', git: 'https://github.com/rails/rails.git', branch: '3-2-stable'
gem 'bundler'

### Database Adapter
platforms :mri_19 do
  gem 'pg'
  gem 'pg_power'
  gem 'rmagick'
  gem 'rails3_libmemcached_store'
end

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'rmagick4j'
  gem 'jruby-rack'
  gem 'jruby-ehcache'
  gem 'jruby-ehcache-rails3', require: 'ehcache'
end

### Oauth
gem 'simple_oauth', "~> 0.1.9"
gem 'omniauth'
gem 'omniauth-oauth', '~> 1.0.1'
gem 'omniauth-oauth2', '1.0.3'
gem 'omniauth-facebook', '1.4.0'
gem 'omniauth-google-oauth2', '~> 0.1.13'
gem 'omniauth-twitter', '~> 0.0.12'
gem 'omniauth-windowslive', git: 'git://github.com/dangerp/omniauth-windowslive.git'
gem 'koala', git: 'git://github.com/arsduo/koala.git', ref: '0239c57c552e4fa36e2caf80d138bad9e3bcf30a'

### Roles and Authentication
gem 'cancan', '~> 1.6.7'
gem 'devise', '~> 2.0'

### Versioning
gem 'paper_trail', '~> 2.6.3'

### Views
gem 'kaminari'
gem 'squeel', '~> 1.0.11'

### File Uploading and Image Processing
gem 'fog', '~> 1.4.0'
gem 'carrierwave', '~> 0.6.2'

### Permalink
gem 'stringex', '~> 1.4'
gem 'friendly_id', '~> 4.0.0'

### Comment System
gem 'opinio', git:  'git://github.com/fred/opinio.git', branch: 'fred'
gem 'rakismet'

gem 'sass', '~> 3.2'
gem 'sass-rails'
gem 'jquery-rails', '~> 2.0.2'

gem 'slim', "~> 1.3.0"
gem 'sinatra'
gem 'redis'
gem 'celluloid'
gem 'sidekiq', "2.6.5"

### JSON and Twitter
gem 'multi_json'
gem 'json'
gem 'twitter', "~> 4.0"

gem 'anytime', git: 'git://github.com/fred/anytime-rails.git'

gem 'nokogiri'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyrhino', require: 'rhino', platform: :jruby
  gem 'therubyracer', "~> 0.10.2", require: 'v8',  platform: :mri_19
  gem 'execjs'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.5'
end

# Settings
gem 'rails_config'

group :production do
  gem 'exception_notification', '~> 2.6.0', require: 'exception_notifier'
end

group :production, :development do
  gem 'unicorn', require: false, platform: :mri_19
end

group :test, :development do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'fuubar'
end

group :development do
  gem 'nifty-generators'
  gem 'hirb'
  gem 'foreman'
  gem 'letter_opener', git: 'git://github.com/fred/letter_opener.git', branch: 'fred'
  gem 'capistrano', '~> 2.13.0', require: false
  gem 'rvm-capistrano', require: false
  # gem 'debugger', "~> 1.3.0", platform: :mri_19
  gem 'pry-rails'
  gem 'brakeman'
  gem 'gettext', "~> 2.2.1", require: false
  gem 'ruby_parser', require: false
  gem 'locale'
  gem 'guard-rspec'
end

group :test do
  gem 'xpath'
  gem 'factory_girl', '~> 4.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'cucumber-rails', '>= 1.0.2'
  gem 'webrat', '~> 0.7.3'
  gem 'capybara', '>= 1.0.1'
  gem 'database_cleaner'
  gem 'launchy', '>= 2.0.5'
  gem 'sunspot_solr', git: 'git://github.com/sunspot/sunspot.git'
  gem 'sunspot_test'
  gem 'turn', '~> 0.8.3', require: false
end

gem 'fast_gettext'
gem 'gettext_i18n_rails'

# Active Admin, loaded at end
gem 'meta_search'
gem 'activeadmin', git: 'git://github.com/fred/active_admin.git', branch: 'no-override'

# Twitter Bootstrap for Rails 3 Asset Pipeline
gem 'less', '~> 2.2.2'
gem 'less-rails', '~> 2.2.6'
gem 'twitter-bootstrap-rails'

gem 'sunspot', git: 'git://github.com/sunspot/sunspot.git'
gem 'sunspot_rails', git: 'git://github.com/sunspot/sunspot.git'
gem 'sitemap_generator'
gem 'tinymce-rails' , '~> 3.5.6'
gem 'tinymce-rails-imageupload', '~> 3.5.6.3'
gem 'simple_captcha', require: 'simple_captcha', git: 'git://github.com/galetahub/simple-captcha.git'
gem 'country-select'
gem 'validates_email_format_of', git: 'git://github.com/alexdunae/validates_email_format_of.git'
gem 'turbo-sprockets-rails3'
gem 'turbolinks'
gem 'jquery-turbolinks'
#gem 'feedzirra'
gem 'newrelic_rpm', '3.5.4.34'
gem 'thumbs_up'
gem 'lazy_high_charts', git: 'git://github.com/michelson/lazy_high_charts.git'
gem 'sql_funk', git: 'git://github.com/FernandoEscher/sql_funk.git'
gem 'tabletastic'

gem 'activerecord-postgres-hstore', github: 'engageis/activerecord-postgres-hstore'
