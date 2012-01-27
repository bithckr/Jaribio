require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Jaribio::RSpecFormatter" do
  let(:output) { StringIO.new }
  let(:formatter) { Jaribio::RSpecFormatter.new(output) }

  it "gets jaribio_key from example"
  it "gets jaribio_key from example group"
  it "gets jaribio_key from parent group"

  it "uses example group full description as key" do
    group = RSpec::Core::ExampleGroup.describe("object")
    example = group.example("example 1")
    # group.run(RSpec::Core::Reporter.new(formatter))
    formatter.instance_eval { 
      @example_group = group
    }
    key, desc = formatter.send(:get_example_key, example)
    key.should == "object example 1"
    desc.should == "object example 1"
  end
end
