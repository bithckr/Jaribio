require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../support/logger_macros')

describe TestCase do
  before(:each) do
    @suite = Factory.build :suite
    @case = Factory.build :test_case, :suites => [@suite]
    @plan = Factory.build :plan
    @plan.suites << @suite
    @execution = Factory.build :execution, :test_case => @case, :plan => @plan
    @case.executions = [@execution]
  end

  it "has many suites" do
    @case.should have(1).suites
  end

  it "has many executed cases" do
    @case.should have(1).executions
  end

  it "has many plans" do
    @case.plans << @plan
    @case.should have(1).plans
  end

  it "can be searched" do
    @case.save!

    # Use default search field
    @cases = TestCase.search(@case.name)
    @cases.size.should eq(1)
    
    # Specify search field
    @cases = TestCase.search("name:#{@case.name}");
    @cases.size.should eq(1)
  end

  it "search accepts a relation" do
    @case.save!
    @cases = TestCase.search(@case.name, TestCase.scoped)
    @cases.size.should eq(1)
  end

  it "has a passing status when the last execution passed" do
    @plan.save!
    @case.save!
    @execution.save!
    @case.status(@plan.id).should eq(Status::PASS)
  end

  it "has a failing status when the last execution failed" do
    @plan.save!
    @case.save!
    @execution.status_code = Status::FAIL
    @execution.save!
    @case.status(@plan.id).should eq(Status::FAIL)
  end

  it "has a UNKNOWN status when no executions are found" do
    @plan.save!
    @case.executions = []
    @case.save!
    @case.status(@plan.id).should eq(Status::UNKNOWN)
  end
  it "has a UNKNOWN status when executed in another plan" do
    @plan.save!
    @case.save!
    @plan2 = Factory.build(:plan)
    @plan2.suites << @suite
    @plan2.save!
    res = @case.last_execution(@plan2.id)
    @case.status(@plan2.id).should eq(Status::UNKNOWN)
  end
  it "has a UNKNOWN status when no executions are found and no plan_id" do
    @case.executions = []
    @case.save!
    @case.status.should eq(Status::UNKNOWN)
  end
  
  it "should generate a unique_key if not provided one" do
    tc = Factory.build :test_case;
    tc.unique_key = nil;
    tc.save.should_not be_false;

    tc.unique_key.should_not be_empty;
    tc.unique_key.should match /[A-Z0-9]+/;
  end
  
  it "should respect user-set unique_key" do
    tc = Factory.build :test_case;
    tc.unique_key = "CNC-123456789";
    tc.save.should_not be_false;

    tc.unique_key.should_not be_empty;
    tc.unique_key.should eq "CNC-123456789";
  end

  it "can deep-copy" do
    @case.save!
    new_case = @case.deep_clone
    new_case.save!
    new_case.id.should_not eq @case.id
    new_case.suite_ids.should eq @case.suite_ids
  end

end
