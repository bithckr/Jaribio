require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Suites" do

  describe "GET /suites" do
    before(:each) do
      @user = login_any_user
    end

    it "works! (now write some real specs)" do
      visit suites_path
      current_path.should == suites_path
    end
  end
end
