require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TestCases" do

  describe "GET /cases" do
    before(:each) do
      @user = login_any_user
      @test_case = Factory.create(:test_case)
    end

    it "lists test cases" do
      visit test_cases_path
      page.should have_content(@test_case.name)  
      page.should have_content(@test_case.user.email)  
    end
  end
end
