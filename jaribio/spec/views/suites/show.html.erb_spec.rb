require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "suites/show.html.erb" do
  before(:each) do
    @suite = assign(:suite, Factory.create(:suite))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@suite.name}/)
  end
end
