require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Execution do
  before(:each) do
    @user = Factory.build :user
    @plan = Factory.build :plan
    @test_case = Factory.build :test_case
    @execution = Factory.build :execution, :plan => @plan, :test_case => @test_case, :user => @user
  end
  it "has a user" do
    @execution.user.should eq(@user)
  end

  it "has a plan" do
    @execution.plan.should eq(@plan)
  end

  it "has a test_case" do
    @execution.test_case.should eq(@test_case)
  end
end
