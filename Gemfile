source 'http://rubygems.org'


### Basic
gem 'rack', '1.3.5'
gem 'rack-cache'
gem 'rake', '0.9.2.2'
gem 'rails', '3.1.3'
gem 'bundler', '>= 1.0.0'
gem 'thin', '1.3.1', :require => false

### Database
gem 'mysql2'

### Roles and Authentication
gem "cancan" 
gem 'devise' # Devise must be required before RailsAdmin

### Versioning
gem 'paper_trail'

### Views
gem 'kaminari'
gem "squeel"
gem 'nested_form'

### File Uploading and Image Processing
gem 'rmagick', '2.13.1'
gem "fog"
gem 'carrierwave'

### Parsing
gem 'nokogiri'

### Permalink
gem 'stringex'
gem "friendly_id", :git => "git://github.com/norman/friendly_id.git"

### Queue
# gem 'resque'
# gem 'resque-timeout', '1.0.0'
# gem 'resque-ensure-connected'
# gem 'SystemTimer', '1.2.1', :platforms => :ruby_18 #(not using ruby 1.8)

### ASYNC Mailing
# gem 'mail'
# gem 'resque_mailer'



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'json'
  gem 'sass'
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

# jQuery
gem 'jquery-rails'

# Search and Indexing
gem 'sunspot'
gem 'sunspot_rails'
gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development
gem 'sunspot_with_kaminari'

# Nice progress when rake indexing with solr
gem 'progress_bar'

# Settings
gem "rails-settings-cached", 
    :require => 'rails-settings', 
    :git => 'git://github.com/huacnlee/rails-settings-cached.git'

### i18n Translation on DB
gem 'i18n-active_record',
    :require => 'i18n/active_record',
    :git => 'git://github.com/svenfuchs/i18n-active_record.git'


group :development do
  gem "rspec-rails", ">= 2.6.1"
  gem "nifty-generators"
  gem 'hirb'
end

group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', :require => false
  gem "rspec-rails", ">= 2.6.1"
  gem "factory_girl_rails", "~> 1.2"
end
