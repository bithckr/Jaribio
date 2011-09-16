require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TestCases" do

  describe "GET /cases" do
    before(:all) do
      @user = Factory.create(:user)
      @user.confirm!

      @test_case = Factory.create(:test_case)
    end

    it "lists test cases" do
      login @user
      get test_cases_path
      response.status.should be(200)
      page.should have_content(@test_case.name)  
      page.should have_content(@test_case.user.email)  
    end
  end
end
