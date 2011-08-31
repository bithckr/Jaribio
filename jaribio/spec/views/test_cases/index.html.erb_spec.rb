require 'spec_helper'

describe "test_cases/index.html.erb" do
  before(:each) do
    assign(:test_cases, [
      stub_model(TestCase,
        :text => "MyText",
        :expectations => "MyText"
      ),
      stub_model(TestCase,
        :text => "MyText",
        :expectations => "MyText"
      )
    ])
  end

  it "renders a list of cases" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
