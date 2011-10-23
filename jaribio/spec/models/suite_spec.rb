require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Suite do
  before(:each) do
    @case = Factory.build :test_case
    @issue = Factory.build :issue
    @plan = Factory.build :plan
    @suite = Factory.build :suite, :plans => [@plan], :issues => [@issue], :test_cases => [@case]
    @execution = Factory.build :execution, :plan => @plan, :test_case => @case
    @plan.suites = [@suite]
    @plan.executions = [@execution]
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

  it "can be searched" do
    @suite.save!
    suites = Suite.search(@suite.name)
    suites.size.should eq(1)
  end

  it "search accepts a relation" do
    @suite.save!
    suites = Suite.search(@suite.name, Suite.scoped)
    suites.size.should eq(1)
  end

  it "can list unrelated test cases" do
    @suite.save!
    cases = @suite.available_test_cases
    cases.size.should eq(0)

    Factory.create :test_case
    cases = @suite.available_test_cases
    cases.size.should eq(1)
  end

  describe "with one execution per test case" do

    it "that passed should have a passing status" do
      @plan.save!
      @case.save!
      @suite.save!
      @suite.status(@plan_id).should eq(Status::PASS)
    end

    it "that failed should have a failing status" do
      fail_exec = Factory.build(:execution, :plan => @plan, :test_case => @case, :status_code => Status::FAIL)
      @plan.executions << fail_exec
      @plan.save!
      @case.save!
      @suite.save!
      @suite.status(@plan.id).should eq(Status::FAIL)
      @plan.executions.size.should eq(2)
    end
  end

  describe "with multiple executions per test case" do
    before(:each) do
      @suite = Factory.build(:suite)
      @plan = Factory.build(:plan, :suites => [@suite])
      @test_case = Factory.build(:test_case, :suites => [@suite])
      @pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      @fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
    end

    it "where test case passed then fails" do
      @suite.save!
      @plan.save!
      @test_case.save!
      @pass_execution.save!
      sleep(2)
      @fail_execution.save!
      @suite.status(@plan.id).should eq(Status::FAIL)
      @plan.executions.size.should eq(2)
    end

    it "where test case failed then passes" do
      @plan.save!
      @test_case.save!
      @fail_execution.save!
      sleep(2)
      @pass_execution.save!
      @suite.status(@plan.id).should eq(Status::PASS)
      @plan.executions.size.should eq(2)
    end
  end

  describe "with no executed test case" do

    it "should have a unknown status" do
      @suite.status.should eq(Status::UNKNOWN)
    end
  end
end
