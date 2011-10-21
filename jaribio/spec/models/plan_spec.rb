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

  describe "with one execution per test case" do

    it "that passed should have a passing status" do
      @plan.save!
      @plan.status.should eq(Status::PASS)
    end

    it "that failed should have a failing status" do
      fail_exec = Factory.build(:execution, :plan => @plan, :status_code => Status::FAIL)
      @plan.executions << fail_exec
      @plan.save!
      @plan.status.should eq(Status::FAIL)
      @plan.executions.size.should eq(2)
    end
  end

  describe "with multiple executions per test case" do
    before(:each) do
      @plan = Factory.build(:plan)
      @test_case = Factory.build(:test_case)
      @pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      @fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
    end

    it "where test case passed then fails" do
      @plan.save!
      @test_case.save!
      @pass_execution.save!
      sleep(2)
      @fail_execution.save!
      @plan.status.should eq(Status::FAIL)
      @plan.executions.size.should eq(2)
    end

    it "where test case failed then passes" do
      @plan.save!
      @test_case.save!
      @fail_execution.save!
      sleep(2)
      @pass_execution.save!
      @plan.status.should eq(Status::PASS)
      @plan.executions.size.should eq(2)
    end
  end

  describe "with no executed test case" do

    it "should have a unknown status" do
      @plan.status.should eq(Status::UNKNOWN)
    end
  end
end
