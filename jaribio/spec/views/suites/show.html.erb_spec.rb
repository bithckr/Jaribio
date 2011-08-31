require 'spec_helper'

describe "suites/show.html.erb" do
  before(:each) do
    @suite = assign(:suite, stub_model(Suite,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
