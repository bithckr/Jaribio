require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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

    it "uses example group full description as key" do
      example = example_group.example("example 1")
      verify_key_and_description(example, 'object', 'object')
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
      example_group.run(formatter)
    end

    it "is a hash with all keys found while testing" do
      formatter.results.keys.sort.should eql ['e2', 'g1', 'g1e2', 'object']
    end

    it "values are a hash with description and failed state" do
      formatter.results.should eql({ 
        'e2' => {
        :description => 'object example 2',
        :failed => true
      },
        'g1' => {
        :description => 'object subgroup',
        :failed => true
      },
        'g1e2' => {
        :description => 'object subgroup example 2',
        :failed => true
      },
        'object' => {
        :description => 'object',
        :failed => true
      },
      })
    end
  end

  it "has output indicating when a specified key does not exist in Jaribio"
  it "creates new executions for open plans and existing test cases"

  describe "when configured to create test cases" do
    it "creates new test cases if the test case does not exist"
    it "creates new executions for open plans and new test cases"
    it "creates new executions for open plans and existing test cases"
  end
end
