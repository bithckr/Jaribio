require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "test_cases/new.html.erb" do
  before(:each) do
    @suite = Factory.build :suite
    assign(:test_case, Factory.build(:test_case, :suites => [@suite]))
  end

  it "renders new case form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_cases_path, :method => "post" do
      assert_select "textarea#test_case_text", :name => "test_case[text]"
      assert_select "textarea#test_case_expectations", :name => "test_case[expectations]"
    end
  end
end
