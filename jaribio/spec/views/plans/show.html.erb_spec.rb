require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "plans/show.html.erb" do
  before(:each) do
    @plan = assign(:plan, Factory.create(:plan))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@plan.name}/)
  end
end
