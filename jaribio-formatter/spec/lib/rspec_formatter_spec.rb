require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Jaribio::RSpecFormatter" do
  let(:output) { StringIO.new }
  let(:formatter) do 
    formatter = Jaribio::RSpecFormatter.new(output)
    g = example_group
    formatter.instance_eval { 
      @example_group = g
    }
    formatter
  end
  let(:example_group) { RSpec::Core::ExampleGroup.describe("object") }

  def verify_key_and_description(example, expected_key, expected_description)
    key, desc = formatter.send(:get_example_key, example)
    key.should == expected_key
    desc.should == expected_description
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
