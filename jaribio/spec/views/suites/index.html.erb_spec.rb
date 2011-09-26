require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "suites/index.html.erb" do
  before(:each) do
    @suites = [
      Factory.create(:suite),
      Factory.create(:suite)
    ]
    @suites.stub!(:current_page).and_return(1)
    @suites.stub!(:num_pages).and_return(1)
    @suites.stub!(:limit_value).and_return(1)
    assign(:suites, @suites)
  end

  it "renders a list of suites" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @suites[0].name, :count => 1
    assert_select "tr>td", :text => @suites[1].name, :count => 1
  end
end
