require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Execution do
  before(:each) do
    @user = Factory.build :user
    @plan = Factory.build :plan
    @suite = Factory.build :suite
    @execution = Factory.build :execution, :executable => @plan, :user => @user
  end
  it "has a user" do
    @execution.user.should eq(@user)
  end

  it "is executable" do
    # Verify the polymorphic relationship, test with both plan and suite
    @execution.executable.should eq(@plan)
    @execution = Factory.build :execution, :executable => @suite, :user => @user
    @execution.executable.should eq(@suite)
  end
end
