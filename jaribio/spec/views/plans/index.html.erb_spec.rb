require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "plans/index.html.erb" do
  before(:each) do
    @plans = [
      Factory.create(:plan),
      Factory.create(:plan)
    ]
    @plans.stub!(:current_page).and_return(1)
    @plans.stub!(:num_pages).and_return(1)
    @plans.stub!(:limit_value).and_return(1)
    assign(:plans, @plans)
  end

  it "renders a list of plans" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @plans[0].name, :count => 1
    assert_select "tr>td", :text => @plans[1].name, :count => 1
  end
end
