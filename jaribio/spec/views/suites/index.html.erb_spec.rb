require 'spec_helper'

describe "suites/index.html.erb" do
  before(:each) do
    assign(:suites, [
      stub_model(Suite,
        :name => "Name"
      ),
      stub_model(Suite,
        :name => "Name"
      )
    ])
  end

  it "renders a list of suites" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
