require 'spec_helper'

describe "suites/edit.html.erb" do
  before(:each) do
    @suite = assign(:suite, stub_model(Suite,
      :name => "MyString"
    ))
  end

  it "renders the edit suite form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => suites_path(@suite), :method => "post" do
      assert_select "input#suite_name", :name => "suite[name]"
    end
  end
end
