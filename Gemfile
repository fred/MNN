source 'http://rubygems.org'

### Basic
gem 'rack'
gem 'rack-cache'
gem 'rake'
gem 'rails', '~> 3.2.17'
gem 'bundler'

### Database Adapter
platforms :ruby do
  gem 'pg'
  gem 'pg_power'
  gem 'rails3_libmemcached_store'
end

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'jruby-rack'
  gem 'jruby-memcached'
end

### Oauth
gem 'simple_oauth'
gem 'omniauth'
gem 'omniauth-oauth'
gem 'omniauth-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'omniauth-windowslive', git: 'git://github.com/dangerp/omniauth-windowslive.git'
gem 'koala'

### Roles and Authentication
gem 'cancancan'
gem 'devise', '~> 3.2.0'

### Versioning
gem 'paper_trail', '~> 2.6.3'

### Views
gem 'kaminari'
gem 'squeel'

### File Uploading and Image Processing
gem 'mini_magick'
gem 'fog', '~> 1.21.0'
gem 'carrierwave', '~> 0.10.0'

### Permalink
gem 'friendly_id', '~> 4.0'

### Comment System
gem 'opinio', git:  'git://github.com/fred/opinio.git', branch: 'fred'
gem 'rakismet'

gem 'sass', '~> 3.2'
gem 'sass-rails'
gem 'jquery-rails', '~> 2.2.1'
gem 'jquery-ui-rails'

gem 'haml'
gem 'slim'
gem 'sinatra'
gem 'redis'
gem 'celluloid'
gem 'sidekiq', '~> 2.17.3'

### JSON and Twitter
gem 'multi_json'
gem 'json'
gem 'twitter', "~> 4.0"
# gem 'anytime_rails', git: 'git://github.com/fred/anytime-rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyrhino', require: 'rhino', platform: :jruby
  gem 'therubyracer', require: 'v8',  platform: :ruby
  gem 'execjs'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.5'
end

# Settings
gem 'rails_config'

group :production do
  gem 'exception_notification', '~> 2.6.0', require: 'exception_notifier'
  gem 'newrelic_rpm'
end

group :production, :development do
  gem 'unicorn', require: false, platform: :ruby
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
  gem 'letter_opener'
  gem 'net-scp', '~> 1.1'
  gem 'capistrano', '~> 2.15.5', require: false
  gem 'rvm-capistrano', require: false
  gem 'capistrano-ext', require: false
  gem 'pry-rails'
  gem 'gettext', "~> 2.2.1", require: false
  gem 'ruby_parser', require: false
  gem 'locale'
end

group :test do
  gem 'xpath'
  gem 'factory_girl', '~> 4.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'cucumber-rails', require: false
  gem 'webrat', '~> 0.7.3'
  gem 'capybara', '>= 1.0.1'
  gem 'database_cleaner'
  gem 'launchy', '>= 2.0.5'
  gem 'sunspot_solr', git: 'git://github.com/sunspot/sunspot.git', ref: 'c768d11731e103a7c1794dc29172fbe8fe8b7115'
  gem 'sunspot_test'
  gem 'turn', '~> 0.8.3', require: false
end

gem 'fast_gettext'
gem 'gettext_i18n_rails'

# Active Admin, loaded at end
gem 'meta_search'
gem 'activeadmin', '~> 0.6.3'

# Twitter Bootstrap for Rails 3 Asset Pipeline
gem 'less'
gem 'less-rails'
gem 'twitter-bootstrap-rails'

gem 'sunspot', git: 'git://github.com/sunspot/sunspot.git', ref: 'c768d11731e103a7c1794dc29172fbe8fe8b7115'
gem 'sunspot_rails', git: 'git://github.com/sunspot/sunspot.git', ref: 'c768d11731e103a7c1794dc29172fbe8fe8b7115'
gem 'sitemap_generator', '~> 3.4'
gem 'tinymce-rails' , '~> 3.5.8.3'
gem 'tinymce-rails-imageupload', '~> 3.5.8.6'
gem 'simple_captcha', require: 'simple_captcha', git: 'git://github.com/galetahub/simple-captcha.git'
gem 'country-select'
gem 'validates_email_format_of', git: 'git://github.com/alexdunae/validates_email_format_of.git'
gem 'turbo-sprockets-rails3'
gem 'turbolinks'

gem 'thumbs_up'
gem 'lazy_high_charts', git: 'git://github.com/michelson/lazy_high_charts.git'
gem 'sql_funk', git: 'git://github.com/FernandoEscher/sql_funk.git'
gem 'tabletastic'

gem 'activerecord-postgres-hstore', github: 'engageis/activerecord-postgres-hstore'

