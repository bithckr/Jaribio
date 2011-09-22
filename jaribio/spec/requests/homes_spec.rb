require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Home" do
  describe "GET /home" do
    it "works! (now write some real specs)" do
      visit home_path
      current_path.should == home_path
    end
  end
end
