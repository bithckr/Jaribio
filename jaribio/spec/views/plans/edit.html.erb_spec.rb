require 'spec_helper'

describe "plans/edit.html.erb" do
  before(:each) do
    @plan = assign(:plan, stub_model(Plan,
      :name => "MyString"
    ))
  end

  it "renders the edit plan form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => plans_path(@plan), :method => "post" do
      assert_select "input#plan_name", :name => "plan[name]"
    end
  end
end
