require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "suites/index.html.erb" do
  before(:each) do
    assign(:suites, [
      Factory.create(:suite, :name => 'Name'),
      Factory.create(:suite, :name => 'Name')
    ])
  end

  it "renders a list of suites" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
