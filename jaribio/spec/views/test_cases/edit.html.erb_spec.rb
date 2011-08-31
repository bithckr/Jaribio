require 'spec_helper'

describe "test_cases/edit.html.erb" do
  before(:each) do
    @test_case = assign(:test_case, stub_model(TestCase,
      :text => "MyText",
      :expectations => "MyText"
    ))
  end

  it "renders the edit case form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => test_cases_path(@test_case), :method => "post" do
      assert_select "textarea#test_case_text", :name => "test_case[text]"
      assert_select "textarea#test_case_expectations", :name => "test_case[expectations]"
    end
  end
end
