require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Plan do
  before(:each) do
    @suite = Factory.build :suite
    @plan = Factory.build :plan, :suites => [@suite]
    @test_case = Factory.build :test_case, :suites => [@suite]
    @execution = Factory.build :execution, :plan => @plan, :test_case => @test_case
    @plan.executions = [@execution]
  end

  it "has many suites" do
    @plan.should have(1).suites
  end

  it "has many executions" do
    @plan.should have(1).executions
  end

  it "has a user" do
    @plan.should respond_to(:user)
  end

  it "can be searched" do
    sql = Plan.search(@plan.name).to_sql
    sql.should == %Q{SELECT `plans`.* FROM `plans`  WHERE (`plans`.`name` LIKE '%#{@plan.name}%')}
  end

  it "search accepts a relation" do
    sql = Plan.search(@plan.name, Plan.scoped).to_sql
    sql.should == %Q{SELECT `plans`.* FROM `plans`  WHERE (`plans`.`name` LIKE '%#{@plan.name}%')}
  end

  it "can list unrelated suites" do
    @plan.should respond_to(:available_suites)
    sql = @plan.available_suites.to_sql
    sql.should == %Q{SELECT `suites`.* FROM `suites`  WHERE (`suites`.`id` NOT IN (SELECT `suites`.`id` FROM `suites` INNER JOIN `plans_suites` ON `suites`.`id` = `plans_suites`.`suite_id` WHERE `plans_suites`.`plan_id` IS NULL))}
  end

  describe "with one execution per test case" do
    it "that passed should have a passing status" do
      @plan.save!
      @plan.reload
      @plan.status[0].should eq(Status::PASS)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(0)
      @plan.executions.size.should eq(1)
    end

    it "that failed should have a failing status" do
      fail_exec = Factory.build(:execution, :plan => @plan, :status_code => Status::FAIL)
      @plan.executions << fail_exec
      @plan.save!
      @plan.reload
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(1)
      @plan.status[3].should eq(-1)
      @plan.executions.size.should eq(2)
    end
  end

  describe "with multiple executions per test case" do
    before(:each) do
      @plan.executions = []
      @pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      @fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
    end

    it "where test case passed then fails" do
      @plan.save!
      @pass_execution.created_at = 1.day.ago
      @pass_execution.save!
      @fail_execution.save!
      @plan.reload
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(0)
      @plan.status[2].should eq(1)
      @plan.status[3].should eq(0)
      @plan.executions.size.should eq(2)
    end

    it "where test case failed then passes" do
      @plan.save!
      @fail_execution.created_at = 1.day.ago
      @fail_execution.save!
      @pass_execution.save!
      @plan.reload
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
    it "should have a unknown status when any test case is unknown" do
      pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      @suite.test_cases = [@test_case, test_case2]
      @plan.executions << pass_execution
      @plan.save!
      @plan.status[0].should eq(Status::UNKNOWN)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(1)
    end

    it "should have a unknown status when all test cases are unknown" do
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      @suite.test_cases = [@test_case, test_case2]
      @plan.save!
      @plan.status[0].should eq(Status::UNKNOWN)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(1)
    end

    it "should have a fail status when atleast one test case is failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      @suite.test_cases = [@test_case, test_case2]
      @plan.executions << fail_execution
      @plan.save!
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(0)
      @plan.status[2].should eq(1)
      @plan.status[3].should eq(1)
    end
  end

  describe "with multiple test cases per suite" do
    before(:each) do
      @plan.executions = []
    end

    it "has a failing status if all are failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      fail_execution2 = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => test_case2)
      @suite.test_cases = [@test_case, test_case2]
      @plan.executions << fail_execution
      @plan.executions << fail_execution2
      @plan.save!
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(0)
      @plan.status[2].should eq(2)
      @plan.status[3].should eq(0)
    end

    it "has a passing status if all are passing" do
      pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      pass_execution2 = Factory.build(:execution, :plan => @plan, :test_case => test_case2)
      @suite.test_cases = [@test_case, test_case2]
      @plan.executions << pass_execution
      @plan.executions << pass_execution2
      @plan.save!
      @plan.status[0].should eq(Status::PASS)
      @plan.status[1].should eq(2)
      @plan.status[2].should eq(0)
      @plan.status[3].should eq(0)
    end

    it "has a failing status if one is passing and one is failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      test_case2 = Factory.build(:test_case, :suites => [@suite])
      pass_execution2 = Factory.build(:execution, :plan => @plan, :test_case => test_case2)
      @suite.test_cases = [@test_case, test_case2]
      @plan.executions << fail_execution
      @plan.executions << pass_execution2
      @plan.save!
      @plan.status[0].should eq(Status::FAIL)
      @plan.status[1].should eq(1)
      @plan.status[2].should eq(1)
      @plan.status[3].should eq(0)
    end
  end
end
