require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  before(:each) do
  end

  describe "status_class_helper" do
    it "returns 'pass' if status is Status::PASS" do
      status_class_helper(Status::PASS).should == 'pass'
    end

    it "returns 'fail' if status is Status::FAIL" do
      status_class_helper(Status::FAIL).should == 'fail'
    end

    it "returns 'unknown' if status is any other value" do
      status_class_helper(nil).should == 'unknown'
    end
  end

  describe "status_text" do
    it "returns 'PASS' if status is Status::PASS" do
      status_text(Status::PASS).should == 'PASS'
    end

    it "returns 'FAIL' if status is Status::FAIL" do
      status_text(Status::FAIL).should == 'FAIL'
    end

    it "returns 'UNKNOWN' if status is any other value" do
      status_text(nil).should == 'UNKNOWN'
    end
  end

  describe "status_checked_helper" do
    it "returns true if status and expected are ==" do
      status_checked_helper(Status::PASS, Status::PASS).should be_true
    end

    it "returns false if status and expected are not ==" do
      status_checked_helper(Status::PASS, Status::FAIL).should be_false
    end
  end

  describe "status_disabled_helper" do
    it "returns false if status == Status::UNKNOWN" do
      status_disabled_helper(Status::UNKNOWN).should be_false
    end

    it "returns false by default" do
      status_disabled_helper().should be_false
    end

    it "returns true if status is not == Status::UNKNOWN" do
      status_disabled_helper(Status::PASS).should be_true
    end
  end

end
