require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TestCases" do
  describe "GET /cases" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get test_cases_path
      response.status.should be(200)
    end
  end
end
