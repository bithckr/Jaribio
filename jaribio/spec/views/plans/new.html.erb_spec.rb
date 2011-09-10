require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "plans/new.html.erb" do
  before(:each) do
    assign(:plan, Factory.build(:plan))
  end

  it "renders new plan form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => plans_path, :method => "post" do
      assert_select "input#plan_name", :name => "plan[name]"
    end
  end
end
