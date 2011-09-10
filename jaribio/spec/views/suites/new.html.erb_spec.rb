require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "suites/new.html.erb" do
  before(:each) do
    assign(:suite, Factory.build(:suite))
  end

  it "renders new suite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => suites_path, :method => "post" do
      assert_select "input#suite_name", :name => "suite[name]"
    end
  end
end
