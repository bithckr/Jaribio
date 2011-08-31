require 'spec_helper'

describe "test_cases/show.html.erb" do
  before(:each) do
    @test_case = assign(:test_case, stub_model(TestCase,
      :text => "MyText",
      :expectations => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
