require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Steps" do
  describe "GET /steps" do
    before(:each) do
      @user = login_any_user
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit steps_path
      page.driver.status_code.should be(200)
    end
  end
end
