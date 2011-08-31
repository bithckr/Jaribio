require 'spec_helper'

describe Case do
  subject do
    @suite = Factory.build :suite
    @executed_case = Factory.build :executed_case
    Factory.build :case, :suites => [@suite], :executed_cases => [@executed_case]
  end

  it "has many suites" do
    subject().should have(1).suites
  end

  it "has many executed cases" do
    subject().should have(1).executed_cases
  end

end
