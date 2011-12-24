require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Plan do
  before(:each) do
    @suite = Factory.build :suite
    @plan = Factory.build :plan, :suites => [@suite]
    @test_case = Factory.build :test_case, :suites => [@suite]
    @execution = Factory.build :execution, :plan => @plan, :test_case => @test_case
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
      @suite.save!
      @plan.save!
      @test_case.save!
      @execution.save!
      @plan.status[0].should eq(Status::PASS)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(0)
    end

    it "that failed should have a failing status" do
      fail_exec = Factory.build(:execution, :plan => @plan, :status_code => Status::FAIL)
      @plan.executions << fail_exec
      @plan.save!
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(1)
      @plan.status[3].should eq(-1)
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
      @plan.save!
      @test_case.save!
      @pass_execution.save!
      sleep(2)
      @fail_execution.save!
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(0)
      @plan.status[2].should eq(1)
      @plan.status[3].should eq(0)
      @plan.executions.size.should eq(2)
    end

    it "where test case failed then passes" do
      @suite.save!
      @plan.save!
      @test_case.save!
      @fail_execution.save!
      sleep(2)
      @pass_execution.save!
      @plan.status[0].should eq(Status::PASS)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(0)
      @plan.executions.size.should eq(2)
    end
  end

  describe "with no executed test case" do

    it "should have a unknown status" do
      @plan.status[0].should eq(Status::UNKNOWN)
      @plan.status[1].should eq(0)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(0)
    end
  end

  describe "with some test cases not executed" do
    before(:all) do
      @suite = Factory.build(:suite)
      @plan = Factory.build(:plan, :suites => [@suite])
      @test_case = Factory.build(:test_case, :suites => [@suite])
    end

    it "should have a unknown status when any test case is unknown" do
      pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      @suite.save!
      @plan.save!
      @test_case.save!
      pass_execution.save!
      test_case2.save!
      @suite.test_cases = [@test_case, test_case2]
      @plan.status[0].should eq(Status::UNKNOWN)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(1)
    end

    it "should have a unknown status when all test cases are unknown" do
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      @suite.save!
      @plan.save!
      @test_case.save!
      test_case2.save!
      @suite.test_cases = [@test_case, test_case2]
      @plan.status[0].should eq(Status::UNKNOWN)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(1)
    end

    it "should have a fail status when atleast one test case is failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      @suite.save!
      @plan.save!
      @test_case.save!
      fail_execution.save!
      test_case2.save!
      @suite.test_cases = [@test_case, test_case2]
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(0)
      @plan.status[2].should eq(1)
      @plan.status[3].should eq(1)
    end
  end

  describe "with multiple test cases per suite" do
    before(:all) do
      @suite = Factory.build(:suite)
      @plan = Factory.build(:plan, :suites => [@suite])
      @test_case = Factory.build(:test_case, :suites => [@suite])
    end

    it "has a failing status if all are failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      fail_execution2 = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => test_case2)
      @suite.save!
      @plan.save!
      @test_case.save!
      fail_execution.save!
      fail_execution2.save!
      test_case2.save!
      @suite.test_cases = [@test_case, test_case2]
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(0)
      @plan.status[2].should eq(2)
      @plan.status[3].should eq(0)
    end

    it "has a passing status if all are passing" do
      pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      pass_execution2 = Factory.build(:execution, :plan => @plan, :test_case => test_case2)
      @suite.save!
      @plan.save!
      @test_case.save!
      pass_execution.save!
      pass_execution2.save!
      test_case2.save!
      @suite.test_cases = [@test_case, test_case2]
      @plan.status[0].should eq(Status::PASS)
      @plan.status[1].should eq(2)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(0)
    end

    it "has a failing status if one is passing and one is failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      pass_execution2 = Factory.build(:execution, :plan => @plan, :test_case => test_case2)
      @suite.save!
      @plan.save!
      @test_case.save!
      fail_execution.save!
      pass_execution2.save!
      test_case2.save!
      @suite.test_cases = [@test_case, test_case2]
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(1)
      @plan.status[3].should eq(0)
    end
  end
end
