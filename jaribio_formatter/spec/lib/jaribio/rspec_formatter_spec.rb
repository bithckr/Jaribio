require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'base64'
require 'digest/md5'

describe "Jaribio::RSpecFormatter" do
  let(:output) { StringIO.new }
  let(:example_group) { RSpec::Core::ExampleGroup.describe("object") }

  describe "#get_example_key" do
    def verify_key_and_description(example, expected_key, expected_description)
      key, desc = formatter.send(:get_example_key, example)
      key.should == expected_key
      desc.should == expected_description
    end

    let(:formatter) do 
      formatter = Jaribio::RSpecFormatter.new(output)
      g = example_group
      formatter.instance_eval { 
        @example_group = g
      }
      formatter
    end

    it "uses example group full description as key when jaribio_key not defined" do
      group = example_group.describe("method")
      example = group.example("example 1")
      formatter.instance_eval {
        @example_group = group
      }
      verify_key_and_description(example, Base64.strict_encode64(Digest::MD5.digest('object method')), 'object method')
    end

    it "gets jaribio_key from example" do
      example = example_group.example("example 1", :jaribio_key => 'abc123')
      verify_key_and_description(example, 'abc123', 'object example 1')
    end

    it "gets jaribio_key from example group" do
      group = RSpec::Core::ExampleGroup.describe("object", 
                                                 :jaribio_key => 'abc123')
      formatter.instance_eval { 
        @example_group = group
      }
      example = group.example("example 1")
      verify_key_and_description(example, 'abc123', 'object')
    end

    it "gets jaribio_key from parent group" do
      group = example_group.describe("method", :jaribio_key => 'group123')
      group2 = group.describe("context")
      example = group2.example("example 1")
      formatter.instance_eval { 
        @example_group = group2
      }
      verify_key_and_description(example, 'group123', 'object method')
    end

    it "gets jaribio_key from example when example group has different key" do
      group = example_group.describe("method", :jaribio_key => 'group123')
      example = group.example("example 1", :jaribio_key => 'abc123')
      formatter.instance_eval {
        @example_group = group
      }
      verify_key_and_description(example, 'abc123', 'object method example 1')
    end
  end

  describe "#results" do
    let(:formatter) { Jaribio::RSpecFormatter.new(output) }

    before do
      example_group.example("example 1") { fail } 
      example_group.example("example 2", :jaribio_key => 'e2') { fail } 
      g1 = example_group.describe("subgroup", :jaribio_key => 'g1')
      g1.example("example 1") { fail } 
      g1.example("example 2", :jaribio_key => 'g1e2') { fail } 
      g2 = example_group.describe("subgroup2")
      g2.example("example 1") { 1.should eq(1) }
      g2.example("example 2") { fail }
      g2.example("example 3") { 1.should eq(1) }
      example_group.run(formatter)
    end

    it "is a hash with all keys found while testing" do
      formatter.results.keys.sort.should eql [
        'e2', 'g1', 'g1e2', 
        Base64.strict_encode64(Digest::MD5.digest('object')), 
        Base64.strict_encode64(Digest::MD5.digest('object subgroup2'))].sort
    end

    it "results are a hash of key to Jaribio::Record values" do
      formatter.results.should eql({
        'e2' => Jaribio::Record.new(:key => 'e2', :description => 'object example 2', :state => Jaribio::Record::FAIL), 
        'g1' => Jaribio::Record.new(:key => 'g1', :description => 'object subgroup', :state => Jaribio::Record::FAIL), 
        'g1e2' => Jaribio::Record.new(:key => 'g1e2', :description => 'object subgroup example 2', :state => Jaribio::Record::FAIL), 
        Base64.strict_encode64(Digest::MD5.digest('object')) => Jaribio::Record.new(:key => Base64.strict_encode64(Digest::MD5.digest('object')), :description => 'object', :state => Jaribio::Record::FAIL), 
        Base64.strict_encode64(Digest::MD5.digest('object subgroup2')) => Jaribio::Record.new(:key => Base64.strict_encode64(Digest::MD5.digest('object subgroup2')), :description => 'object subgroup2', :state => Jaribio::Record::FAIL),
      })
    end
  end

  it "has output indicating when a specified key does not exist in Jaribio"

  describe "#close" do
    let(:formatter) { Jaribio::RSpecFormatter.new(output) }

    before do
      RSpec.configuration.should_receive(:jaribio_url).at_least(:once).and_return('http://localhost/jaribio')
      RSpec.configuration.should_receive(:jaribio_api_key).at_least(:once).and_return('api_key')
      RSpec.configuration.should_receive(:jaribio_timeout).at_least(:once).and_return(10)
      Jaribio::Record.any_instance.stub(:save)
    end

    it "creates missing test cases" do
      RSpec.configuration.should_receive(:jaribio_auto_create).and_return(true)
      RSpec.configuration.should_receive(:jaribio_plans).and_return([])

      Jaribio::TestCase.should_receive(:find).and_return(nil)
      test_case = double("Jaribio::TestCase")
      Jaribio::TestCase.should_receive(:new).and_return(test_case)
      test_case.should_receive(:save)

      example = example_group.example("example 1", :jaribio_key => 'abc123') { fail } 
      example_group.run(formatter)
      formatter.close()
    end

    it "finds configured plans" do
      RSpec.configuration.should_receive(:jaribio_auto_create).and_return(false)
      RSpec.configuration.should_receive(:jaribio_plans).twice.and_return([1])

      plan = double("Jaribio::Plan")
      plan.should_receive(:open?).and_return(true)
      Jaribio::Plan.should_receive(:find).with(1).once.and_return(plan)

      example = example_group.example("example 1", :jaribio_key => 'abc123') { fail } 
      example_group.run(formatter)
      formatter.close()
    end

  end

  describe "can configure" do
    before do
      RSpec.configure do |c|
        c.jaribio_auto_create = true
      end
    end
    
    it "jaribio url" do 
      RSpec.configuration.should respond_to :jaribio_url
    end

    it "jaribio api key" do
      RSpec.configuration.should respond_to :jaribio_api_key
    end

    it "test case creation" do
      RSpec.configuration.jaribio_auto_create.should be_true
    end

    it "specific plans" do
      RSpec.configuration.should respond_to :jaribio_plans
    end
  end

end
