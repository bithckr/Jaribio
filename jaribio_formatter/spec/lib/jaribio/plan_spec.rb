require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Jaribio::Plan" do
  describe "#open?" do
    it "should be true if closed_at is nil" do
      Jaribio::Plan.new.open?.should be_true
    end

    it "should be false if closed_at is non-nil" do
      p = Jaribio::Plan.new()
      p.closed_at = Time.now
      p.open?.should be_false
    end
  end

end
