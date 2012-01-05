require 'spec_helper'

describe Step do
  before(:each) do
    @test_case = Factory.build :test_case
    @step = Factory.build :step, :test_case => @test_case
  end

  it "has a test case" do
    @step.should respond_to(:test_case)
  end
end
