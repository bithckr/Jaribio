require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "test_cases/index.html.erb" do
  before(:each) do
    @suite = Factory.create :suite

    assign(:test_cases, [
          Factory.create(:test_case, :suites => [@suite]),
          Factory.create(:test_case, :suites => [@suite])
    ])
  end

  it "renders a list of cases" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
