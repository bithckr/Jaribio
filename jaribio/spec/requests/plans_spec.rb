require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Plans" do

  describe "GET /plans" do
    before(:each) do
      @user = login_any_user
    end

    it "works! (now write some real specs)" do
      visit plans_path
      current_path.should == plans_path
    end
  end
end
