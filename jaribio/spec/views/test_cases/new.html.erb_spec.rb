require 'spec_helper'

describe "test_cases/new.html.erb" do
  before(:each) do
    assign(:test_case, stub_model(TestCase,
      :text => "MyText",
      :expectations => "MyText"
    ).as_new_record)
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
