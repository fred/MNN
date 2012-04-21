source 'http://rubygems.org'


### Basic
gem 'rack' #, '1.3.5'
gem 'rack-cache'
gem 'rake' #, '0.9.2.2'
gem 'rails', '3.2.3'
gem 'bundler', '>= 1.1.0'

### Database Adapter
# Using Postgresql for all environments.
gem 'pg'

### Roles and Authentication
gem 'cancan', "~> 1.6.7"
gem 'devise', "~> 2.0.4" # Devise must be required before RailsAdmin

### Versioning
gem 'paper_trail', "~> 2.6.3"

### Views
gem 'kaminari'
gem 'squeel'

### File Uploading and Image Processing
gem 'mini_magick', '~> 3.4'
gem 'fog', "~> 1.3.1"
gem 'carrierwave', "~> 0.5.8"

### S3 Asset hosting
gem "asset_sync"

### Parsing
# gem 'nokogiri'

### Permalink
# gem 'RedCloth'
gem 'stringex'
gem 'friendly_id', '~> 4.0.0'

### Comment System
gem 'opinio', :git => "git://github.com/fred/opinio.git", :branch => "fred"
gem 'rakismet'

### Queue
# Resque Heroku aware branch
gem 'resque', "~> 1.20.0"
gem 'resque_mailer'
gem 'resque-scheduler', :require => 'resque_scheduler'
gem "resque-history", :git => "git://github.com/fred/resque-history.git"

### ASYNC Mailing
# gem 'mail'
# gem 'resque_mailer'

### JSON and Twitter
gem 'multi_json', "~> 1.3.2"
gem 'json', "~> 1.6.6"
# Posting status to twitter
gem 'twitter', "~> 2.2.2"

gem "libv8"
gem "execjs"
gem "therubyracer", :require => 'v8'
gem 'sass'
gem 'sass-rails',  '~> 3.2.3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end


# jQuery
gem 'jquery-rails'

# Search and Indexing
# gem 'sunspot'
# gem 'sunspot_rails'
# gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development
# gem 'sunspot_with_kaminari'


# Settings
gem 'rails-settings-cached', "~> 0.1.2", :require => 'rails-settings'
    # :git => 'git://github.com/huacnlee/rails-settings-cached.git'

### i18n Translation on DB
# gem 'i18n-active_record',
#     :require => 'i18n/active_record',
#     :git => 'git://github.com/svenfuchs/i18n-active_record.git'

group :production do
  gem 'rack-ssl-enforcer', :require => 'rack/ssl-enforcer'
  gem 'unicorn', :require => false
end

group :development do
  gem 'rspec', "~> 2.8.0"
  gem "rspec-rails", "~> 2.8.1"
  gem 'nifty-generators'
  gem 'hirb'
  # Nice progress when rake indexing with solr
  gem 'progress_bar'
  gem 'foreman'
  gem 'thin', :require => false
end

group :test do
  gem 'webrat', "~> 0.7.3"
  gem 'rspec', "~> 2.8.0"
  gem "rspec-rails", "~> 2.8.1"
  gem "factory_girl", "~> 2.5.0"
  gem "factory_girl_rails", '~> 1.6.0'
  gem "cucumber-rails", ">= 1.0.2"
  gem "capybara", ">= 1.0.1"
  gem "database_cleaner", ">= 0.6.7"
  gem "launchy", ">= 2.0.5"
  gem "sqlite3"
  gem 'autotest'
  gem 'autotest-rails'
  gem 'sunspot_test'
  gem 'turn', '~> 0.8.3', :require => false
end



### Active Admin, loaded at end.
gem "meta_search", "~> 1.1.3"
# gem 'activeadmin', "~> 0.4.0"
# gem 'activeadmin', :path => "vendor/gems/active_admin"
gem 'activeadmin', :git => "git://github.com/fred/active_admin.git", :branch => "594"

gem 'tinymce-rails', "3.4.7.0.1"

# Twitter Bootstrap for Rails 3 Asset Pipeline
gem 'twitter-bootstrap-rails', "~> 1.4.3"
  # :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git"


# Error Emails
gem "exception_notification", "~> 2.6.0", :require => 'exception_notifier'
# :git => "git://github.com/smartinez87/exception_notification.git"


###############
## Searching ##
###############

gem 'sunspot', "2.0.0.pre.111215" # :git => "git://github.com/sunspot/sunspot.git"
gem 'sunspot_rails', "2.0.0.pre.111215" # :git => "git://github.com/sunspot/sunspot.git"

### Memcache
gem 'dalli', "~> 2.0.2"

### OpenID 
# gem 'omniauth'
# gem 'omniauth-twitter'
# gem 'omniauth-facebook'
# gem 'omniauth-openid'
# gem 'omniauth-github'
# gem 'omniauth-google_oauth2'

gem 'galetahub-simple_captcha', :require => 'simple_captcha', :git => 'git://github.com/galetahub/simple-captcha.git'


# gem 'jquery_mobile_rails', :git => "git://github.com/fred/jquery-mobile-rails.git", :branch => "110-rc1"


gem 'capistrano', "~> 2.9.0", :require => false
gem 'rvm-capistrano', :require => false

gem 'country-select'

gem 'postmark-rails'
