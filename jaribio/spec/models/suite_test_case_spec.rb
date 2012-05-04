require 'spec_helper'

describe SuiteTestCase do
  before(:each) do
    @suite = Factory.create :suite
    @suite_test_cases = []
    10.times do |n|
      test_case = Factory.create :test_case
      @suite_test_cases.push Factory.build(:suite_test_case, :test_case => test_case, :suite => @suite)
    end
    @suite_case = @suite_test_cases.first
  end

  it "belongs to test case" do
    @suite_case.should respond_to(:test_case)
    @suite_case.should respond_to(:test_case=)
  end

  it "belongs to suite" do
    @suite_case.should respond_to(:suite)
    @suite_case.should respond_to(:suite=)
  end

  # these things are provided by ranked-model
  it "is orderable" do
    @suite_case.should respond_to(:position, :position=)
    @suite_case.position.should == 0
    @suite_test_cases.each { |stc| stc.save! }
    @suite_case.position.should_not be_nil
    # is already first, so insert_at returns nil instead of true
    @suite_case.insert_at().should be_nil
    @suite.test_cases.first.id.should == @suite_case.test_case.id
    @suite_case.move_to_bottom.should be_true
    @suite.test_cases.last.id.should == @suite_case.test_case.id
  end
end
