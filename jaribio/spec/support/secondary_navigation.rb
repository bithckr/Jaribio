shared_examples "a page with secondary navigation" do
  before(:each) do
    visit path
  end

  it "has expected div" do
    page.should have_xpath("//div[@class='secondary-navigation']")
  end

  it "contains 'List'" do
    page.should have_link('List')
  end

  it "contains 'New'" do
    page.should have_link('New')
  end
end
