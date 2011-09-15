require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Issue do
  before(:all) do
    @suite = Factory.build :suite
    @issue = Factory.build :issue, :suites => [@suite]
  end

  it "has many suites" do
    @issue.should have(1).suites
  end
end
