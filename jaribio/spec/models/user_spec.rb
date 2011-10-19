require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @case = Factory.build :test_case
    @plan = Factory.build :plan
    @suite = Factory.build :suite
    @user = Factory.build :user, :suites => [@suite], :plans => [@plan], :test_cases => [@case]
    @execution = Factory.build :execution, :plan => @plan
    @user.executions = [@execution]
  end

  it "has many test cases" do
    @user.should have(1).test_cases
  end

  it "has many suites" do
    @user.should have(1).suites
  end

  it "has many plans" do
    @user.should have(1).plans
  end

  it "has many executions" do
    @user.should have(1).executions
  end
end
