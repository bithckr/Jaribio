require 'spec_helper'

describe Case do
  before(:all) do
    @suite = Factory.build :suite
    @case = Factory.build :case, :suites => [@suite]
    @execution = Factory.build :execution, :executable => @case
    @case.executions = [@execution]
  end

  it "has many suites" do
    @case.should have(1).suites
  end

  it "has many executed cases" do
    @case.should have(1).executions
  end

end
