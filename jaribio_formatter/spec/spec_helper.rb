begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'jaribio_formatter'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.jaribio_url = 'http://jaribio.dev'
  config.jaribio_api_key = 'kpwLvp4JNSMpxskZSypq'
  config.jaribio_auto_create = true
  config.jaribio_timeout = 30
end
