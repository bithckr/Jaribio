require 'spec_helper'

describe "plans/index.html.erb" do
  before(:each) do
    assign(:plans, [
      stub_model(Plan,
        :name => "Name"
      ),
      stub_model(Plan,
        :name => "Name"
      )
    ])
  end

  it "renders a list of plans" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
