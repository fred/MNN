# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'sidekiq/testing/inline'
Rails.logger.level = 4

# Sunspot.session = Sunspot::Rails::StubSessionProxy.new(Sunspot.session)

include ActionDispatch::TestProcess

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  # :documentation, :progress, :html, :textmate
  config.formatter = :progress

  config.include Devise::TestHelpers, type: :controller

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Webrat.configure do |config|
  config.mode = :rails
end

module ItemSpecHelper
  def valid_item_attributes
    { 
      category_id: 1,
      language_id: 1,
      title: 'Some Listing',
      abstract: 'Some Long Abstract',
      body: "some body...",
      draft: false,
      featured: false,
      published_at: Time.now-3600
    }
  end
end

module UserSpecHelper
  def valid_user_attributes
    {
      email: "welcome@gmail.com",
      name: 'My Name',
      password: 'welcome',
      password_confirmation: 'welcome',
    }
  end
end

module NumericMatchers
  RSpec::Matchers.define :greater_than do |expected|
    match do |actual|
      actual > expected
    end
  end
  RSpec::Matchers.define :less_than do |expected|
    match do |actual|
      actual < expected
    end
  end
  RSpec::Matchers.define :less_or_equal do |expected|
    match do |actual|
      actual <= expected
    end
  end
  RSpec::Matchers.define :greater_or_equal do |expected|
    match do |actual|
      actual >= expected
    end
  end
end
