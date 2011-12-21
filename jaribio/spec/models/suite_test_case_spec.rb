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
    @suite_case.should respond_to(:sort_order_position, :sort_order_position=)
    @suite_case.sort_order_position.should be_nil
    @suite_test_cases.each { |stc| stc.save! }
    @suite_case.sort_order_position.should_not be_nil
    @suite_case.sort_order_position = :first
    @suite_case.save!
    @suite.test_cases.first.id.should == @suite_case.test_case.id
    @suite_case.sort_order_position = :last
    @suite_case.save!
    @suite.test_cases.last.id.should == @suite_case.test_case.id
  end
end
