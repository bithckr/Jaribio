require 'spec_helper'

describe PreStep do
  before(:each) do
    @pre_step = Factory.build :pre_step
    @test_case = Factory.build :test_case, :pre_step => @pre_step
    @pre_step.test_cases = [@test_case]
  end

  it "has many test cases" do
    @pre_step.should have(1).test_cases
  end
end
