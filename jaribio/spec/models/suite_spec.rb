require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Suite do
  before(:each) do
    @test_case = Factory.build :test_case
    @issue = Factory.build :issue
    @plan = Factory.build :plan
    @suite = Factory.build :suite, :plans => [@plan], :issues => [@issue], :test_cases => [@test_case]
    @execution = Factory.build :execution, :plan => @plan, :test_case => @test_case
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
    sql = Suite.search(@suite.name).to_sql
    sql.should == %Q{SELECT `suites`.* FROM `suites`  WHERE (`suites`.`name` LIKE '%#{@suite.name}%')}
  end

  it "search accepts a relation" do
    sql = Suite.search(@suite.name, Suite.scoped).to_sql
    sql.should == %Q{SELECT `suites`.* FROM `suites`  WHERE (`suites`.`name` LIKE '%#{@suite.name}%')}
  end

  it "can list unrelated test cases" do
    sql = @suite.available_test_cases.to_sql
    sql.should == %Q{SELECT `test_cases`.* FROM `test_cases`  WHERE (`test_cases`.`id` NOT IN (SELECT `test_cases`.`id` FROM `test_cases` INNER JOIN `suites_test_cases` ON `test_cases`.`id` = `suites_test_cases`.`test_case_id` WHERE `suites_test_cases`.`suite_id` IS NULL))}
  end

  describe "with one execution per test case" do
    it "that passed should have a passing status" do
      @plan.save!
      @suite.status(@plan.id).should eq(Status::PASS)
    end

    it "that failed should have a failing status" do
      fail_exec = Factory.build(:execution, :plan => @plan, :test_case => @test_case, :status_code => Status::FAIL)
      @plan.executions = [fail_exec]
      @plan.save!
      @suite.status(@plan.id).should eq(Status::FAIL)
      @plan.executions.size.should eq(1)
    end
  end

  describe "with multiple executions per test case" do
    before(:each) do
      @plan.executions = []
      @pass_execution = Factory.build(:execution, :test_case => @test_case,
                                      :plan => @plan)
      @fail_execution = Factory.build(:execution, :test_case => @test_case,
                                      :plan => @plan, :status_code => Status::FAIL)
      @plan.executions << @pass_execution
      @plan.executions << @fail_execution
    end

    it "where test case passed then fails" do
      @pass_execution.created_at = 1.day.ago
      @plan.save!
      @plan.reload
      @suite.status(@plan.id).should eq(Status::FAIL)
      @plan.executions.size.should eq(2)
    end

    it "where test case failed then passes" do
      @fail_execution.created_at = 1.day.ago
      @plan.save!
      @plan.reload
      @suite.status(@plan.id).should eq(Status::PASS)
      @plan.executions.size.should eq(2)
    end
  end

  describe "with some test cases not executed" do
    before(:each) do
      @test_case2 = Factory.build(:test_case)
      @suite.test_cases << @test_case2
    end

    it "should have a unknown status when any test case is unknown" do
      pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      @plan.executions << pass_execution
      @plan.save!
      @suite.status.should eq(Status::UNKNOWN)
    end
    
    it "should have a unknown status when all test cases are unknown" do
      @plan.save!
      @suite.status.should eq(Status::UNKNOWN)
    end 

    it "should have a fail status when atleast one test case is failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      @plan.executions << fail_execution
      @plan.save!
      @suite.status.should eq(Status::FAIL)
    end
  end

  describe "with multiple test cases per suite" do
    before(:each) do
      @test_case2 = Factory.build(:test_case)
      @suite.test_cases << @test_case2
    end

    it "has a failing status if all are failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      fail_execution2 = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case2)
      @plan.executions << fail_execution
      @plan.executions << fail_execution2
      @plan.save!
      @suite.status.should eq(Status::FAIL)
    end

    it "has a passing status if all are passing" do
      pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case)
      pass_execution2 = Factory.build(:execution, :plan => @plan, :test_case => @test_case2)
      @plan.executions << pass_execution
      @plan.executions << pass_execution2
      @plan.save!
      @suite.status.should eq(Status::PASS)
    end

    it "has a failing status if one is passing and one is failing" do
      fail_execution = Factory.build(:execution, :status_code => Status::FAIL, :plan => @plan, :test_case => @test_case)
      pass_execution = Factory.build(:execution, :plan => @plan, :test_case => @test_case2)
      @plan.executions << fail_execution
      @plan.executions << pass_execution
      @plan.save!
      @suite.status.should eq(Status::FAIL)
    end
  end
end
