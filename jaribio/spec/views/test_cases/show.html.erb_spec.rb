require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "test_cases/show.html.erb" do
  before(:each) do
    @suite = Factory.create :suite
    @test_case = assign(:test_case, Factory.create(:test_case, :suites => [@suite]))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@test_case.name}/)
  end
end
