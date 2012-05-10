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

# Copied from rspec-core
def sandboxed(&block)
    @orig_config = RSpec.configuration
    @orig_world  = RSpec.world
    new_config = RSpec::Core::Configuration.new
    new_world  = RSpec::Core::World.new(new_config)
    RSpec.instance_variable_set(:@configuration, new_config)
    RSpec.instance_variable_set(:@world, new_world)
    # reconfigure for jaribio
    Jaribio::RSpecFormatter.configure()
    object = Object.new
    object.extend(RSpec::Core::SharedExampleGroup)

    (class << RSpec::Core::ExampleGroup; self; end).class_eval do
      alias_method :orig_run, :run
      def run(reporter=nil)
        @orig_mock_space = RSpec::Mocks::space
        RSpec::Mocks::space = RSpec::Mocks::Space.new
        orig_run(reporter || NullObject.new)
      ensure
        RSpec::Mocks::space = @orig_mock_space
      end
    end

    object.instance_eval(&block)
  ensure
    (class << RSpec::Core::ExampleGroup; self; end).class_eval do
      remove_method :run
      alias_method :run, :orig_run
      remove_method :orig_run
    end

    RSpec.instance_variable_set(:@configuration, @orig_config)
    RSpec.instance_variable_set(:@world, @orig_world)
  end

RSpec.configure do |config|
  config.around {|example| sandboxed { example.run }}

  config.add_formatter 'Jaribio::RSpecFormatter', 
    File.join(File.dirname(__FILE__), 'jaribio.txt')
  config.jaribio_url = 'http://jaribio.dev'
  config.jaribio_api_key = 'kpwLvp4JNSMpxskZSypq'
  config.jaribio_auto_create = true
  config.jaribio_timeout = 30
end
