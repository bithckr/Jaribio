require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Plans" do

  describe "GET /plans" do
    before(:all) do
      @user = Factory.create(:user)
      @user.confirm!
    end

    it "works! (now write some real specs)" do
      login @user
      get plans_path
      response.status.should be(200)
    end
  end
end
