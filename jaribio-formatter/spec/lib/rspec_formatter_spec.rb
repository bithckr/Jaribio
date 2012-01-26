require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Jaribio::RSpecFormatter" do
  let(:output) { StringIO.new }
  let(:formatter) { Jaribio::RSpecFormatter.new(output) }

  it "gets jaribio key" do
    group = RSpec::Core::ExampleGroup.describe("object")
    group.example("example 1")
    group.run(RSpec::Core::Reporter.new(formatter))
    fail "fix this test"
  end
end
