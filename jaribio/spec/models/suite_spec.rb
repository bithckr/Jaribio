require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Suite do
  before(:each) do
    @case = Factory.build :test_case
    @issue = Factory.build :issue
    @plan = Factory.build :plan
    @suite = Factory.build :suite, :plans => [@plan], :issues => [@issue], :test_cases => [@case]
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

  it "has a status"
end
