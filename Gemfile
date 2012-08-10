source 'http://rubygems.org'


### Basic
gem 'rack'
gem 'rack-cache'
gem 'rake'
gem 'rails', '3.2.8'
gem 'bundler'

### Database Adapter
platforms :ruby do
  gem 'pg'
  gem 'unicorn', require: false
  gem 'rmagick'
end

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'puma'
  gem 'rmagick4j'
end

gem 'i18n'

### Oauth
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-windowslive', git: 'git://github.com/dangerp/omniauth-windowslive.git'

### Roles and Authentication
gem 'cancan', '~> 1.6.7'
gem 'devise', '~> 2.0'

### Versioning
gem 'paper_trail', '~> 2.6.3'

### Views
gem 'kaminari'
gem 'squeel'

### File Uploading and Image Processing
gem 'fog', '~> 1.4.0'
gem 'carrierwave', '~> 0.6.2'

### Permalink
gem 'stringex'
gem 'friendly_id', '~> 4.0.0'

### Comment System
gem 'opinio', git:  'git://github.com/fred/opinio.git', branch: 'fred'
gem 'rakismet'

### Queue
gem 'slim'
gem 'sinatra'
gem 'redis'
gem 'sidekiq', '2.0.3'
gem 'celluloid', '0.11.0'

### JSON and Twitter
gem 'multi_json'
gem 'json'
gem 'simple_oauth'
gem 'twitter'

gem 'sass'
gem 'sass-rails'
gem 'jquery-rails'

gem 'anytime', git: 'git://github.com/fred/anytime-rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyrhino', require: 'rhino', platform: :jruby
  gem 'libv8', platform: :mri_19
  gem 'execjs'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.5'
end


# Settings
gem 'rails_config'

group :test, :development do
  gem 'rspec', '~> 2.9.0'
  gem 'rspec-rails', '~> 2.9.0'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end

group :development do
  gem 'nifty-generators'
  gem 'hirb'
  gem 'progress_bar' # Nice progress when rake indexing with solr
  gem 'foreman'
  gem 'letter_opener', git: 'git://github.com/fred/letter_opener.git', branch: 'fred'
  gem 'capistrano', "2.9.0", require: false
  gem 'rvm-capistrano', require: false
  gem 'debugger', platform: :mri_19
  gem 'pry-rails'
  gem 'brakeman'
end

group :test do
  gem 'cucumber-rails', '>= 1.0.2'
  gem 'webrat', '~> 0.7.3'
  gem 'capybara', '>= 1.0.1'
  gem 'database_cleaner'
  gem 'launchy', '>= 2.0.5'
  gem 'sqlite3'
  gem 'autotest'
  gem 'autotest-rails'
  gem 'sunspot_test'
  gem 'turn', '~> 0.8.3', require: false
end



### Active Admin, loaded at end.
gem 'meta_search', '~> 1.1.3'
# gem 'activeadmin', '~> 0.4.0'
# gem 'activeadmin', path: 'vendor/gems/active_admin'
gem 'activeadmin', 
  git: 'git://github.com/fred/active_admin.git',
  branch: '594',
  ref: '62c1dd5f1c9c4d3a4167d57fdf9c36e3e0b2ab02'

gem 'tinymce-rails' , '3.5.2'

# Twitter Bootstrap for Rails 3 Asset Pipeline
gem 'twitter-bootstrap-rails', 
  git: 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

# Error Emails
gem 'exception_notification', '~> 2.6.0', require: 'exception_notifier'
# git:  'git://github.com/smartinez87/exception_notification.git'


###############
## Searching ##
###############

gem 'sunspot', git: 'git://github.com/sunspot/sunspot.git'
gem 'sunspot_rails', git: 'git://github.com/sunspot/sunspot.git'

### Memcache
gem 'dalli', '~> 2.1.0'


gem 'galetahub-simple_captcha', require: 'simple_captcha', git: 'git://github.com/galetahub/simple-captcha.git'
gem 'country-select'
gem 'postmark-rails'
gem 'validates_email_format_of', git: 'git://github.com/alexdunae/validates_email_format_of.git'
gem 'sitemap_generator'

gem 'rack-mini-profiler'

