require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TestCases" do

  describe "GET /cases" do
    before(:all) do
      @user = Factory.create(:user)
      @user.confirm!
    end

    it "works! (now write some real specs)" do
      login @user
      get test_cases_path
      response.status.should be(200)
    end
  end
end
