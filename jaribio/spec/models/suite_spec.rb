require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Suite do
  before(:each) do
    @case = Factory.build :test_case
    @issue = Factory.build :issue
    @plan = Factory.build :plan
    @suite = Factory.build :suite, :plans => [@plan], :issues => [@issue], :test_cases => [@case]
    @execution = Factory.build :execution, :executable => @suite
    @suite.executions = [@execution]
  end

  it "has many test cases" do
    @suite.should have(1).test_cases
  end

  it "has many issues" do
    @suite.should have(1).issues
  end

  it "has many plans" do
    @suite.should have(1).plans
  end

  it "has many executions" do
    @suite.should have(1).executions
  end

  it "can list unrelated test cases"

end
