require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "test_cases/index.html.erb" do
  before(:each) do
    @suite = Factory.create :suite

    @test_cases = [
      Factory.create(:test_case, :suites => [@suite]),
      Factory.create(:test_case, :suites => [@suite])
    ]
    @test_cases.stub!(:current_page).and_return(1)
    @test_cases.stub!(:num_pages).and_return(1)
    @test_cases.stub!(:limit_value).and_return(1)
    assign(:test_cases, @test_cases)
  end

  it "renders a list of cases" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => @test_cases[0].name, :count => 1
    assert_select "tr>td", :text => @test_cases[1].name, :count => 1
  end
end
