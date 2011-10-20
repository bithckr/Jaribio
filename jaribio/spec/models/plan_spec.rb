require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Plan do
  before(:each) do
    @suite = Factory.build :suite
    @plan = Factory.build :plan, :suites => [@suite]
    @execution = Factory.build :execution, :plan => @plan
    @plan.executions = [@execution]
    @user = Factory.build :user
    @plan.user = @user
  end

  it "has many suites" do
    @plan.should have(1).suites
  end

  it "has many executions" do
    @plan.should have(1).executions
  end

  it "has a user" do
    @plan.user.should eq(@user)
  end

  it "can be searched" do
    @plan.save!
    plans = Plan.search(@plan.name)
    plans.size.should eq(1)
  end

  it "search accepts a relation" do
    @plan.save!
    plans = Plan.search(@plan.name, Plan.scoped)
    plans.size.should eq(1)
  end

  it "can list unrelated suites" do
    @plan.save!
    suites = @plan.available_suites
    suites.size.should eq(0)

    Factory.create :suite
    suites = @plan.available_suites
    suites.size.should eq(1)
  end

  it "has a status"
end
