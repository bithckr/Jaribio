require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TestCase do
  before(:all) do
    @suite = Factory.build :suite
    @case = Factory.build :test_case, :suites => [@suite]
    @execution = Factory.build :execution, :executable => @case
    @case.executions = [@execution]
  end

  it "has many suites" do
    @case.should have(1).suites
  end

  it "has many executed cases" do
    @case.should have(1).executions
  end

  it "can be searched" do
    @case.save
    @cases = TestCase.search('ipsum')
    @cases.size.should eq(1)
  end
end
