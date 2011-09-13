require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Suites" do

  describe "GET /suites" do
    before(:all) do
      @user = Factory.create(:user)
      @user.confirm!
    end

    it "works! (now write some real specs)" do
      login @user
      get suites_path
      response.status.should be(200)
    end
  end
end
