require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TestCase do
  before(:each) do
    @suite = Factory.build :suite
    @case = Factory.build :test_case, :suites => [@suite]
    @plan = Factory.build :plan
    @execution = Factory.build :execution, :test_case => @case, :plan => @plan
    @case.executions = [@execution]
  end

  it "has many suites" do
    @case.should have(1).suites
  end

  it "has many executed cases" do
    @case.should have(1).executions
  end

  it "can be searched" do
    @case.save!
    @cases = TestCase.search(@case.name)
    @cases.size.should eq(1)
  end

  it "has a status"
end
