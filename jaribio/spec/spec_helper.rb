begin
  require 'simplecov'
  SimpleCov.start 'rails'
rescue LoadError
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'capybara/rspec'
require 'capybara/rails'
require 'rspec/rails'

# reduce stretches during testing for performance
Devise.stretches = 1

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
  config.include RequestMacros, :type => :request
  config.include LoggerMacros, :type => :model
  config.include Warden::Test::Helpers
end

RSpec.configure do |config|
  config.before(:each) do
    Warden.test_mode!
  end

  config.after(:each) do
    Warden.test_reset!
  end
end
