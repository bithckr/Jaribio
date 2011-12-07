require 'spec_helper'

describe SuiteTestCase do
  before(:each) do
    @case = Factory.build :test_case
    @suite = Factory.build :suite
    @suite_case = Factory.build :suite_test_case, :test_case => @case, :suite => @suite 
  end

  it "belongs to test case" do
    @suite_case.should respond_to(:test_case)
    @suite_case.should respond_to(:test_case=)
  end

  it "belongs to suite" do
    @suite_case.should respond_to(:suite)
    @suite_case.should respond_to(:suite=)
  end

end
