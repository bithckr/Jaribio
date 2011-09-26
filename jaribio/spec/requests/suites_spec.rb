require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Suites" do

  describe "GET /suites" do
    before(:each) do
      @user = login_any_user
      @suite = Factory.create(:suite)
    end

    describe "secondary navigation" do
      before(:each) do
        visit suites_path
      end

      it "exists" do
        page.should have_xpath("//div[@class='secondary-navigation']")
      end

      it "secondary navigation contains 'List'" do
        page.should have_content('List')  
      end

      it "secondary navigation contains 'New'" do
        page.should have_content('New')  
      end
    end

    describe "search" do
      before(:each) do
        visit suites_path
      end

      it "is supported" do
        page.should have_xpath("//div[@class='search']")
      end

      it "with results does include list of suites" do
        fill_in('q', :with => @suite.name)
        click_button('Search')
        page.should have_content('Show')
        page.should have_content('Edit')
        page.should have_content('Destroy')
      end

      it "with no results does not include list of suites" do
        fill_in('q', :with => 'asdf')
        click_button('Search')
        page.should have_no_content('Show')
        page.should have_no_content('Edit')
        page.should have_no_content('Destroy')
      end
    end

    describe "list" do
      before(:each) do
        visit suites_path
      end

      it "of suites" do
        page.should have_content(@suite.name)  
        page.should have_content(@suite.user.email)  
        page.should have_content('Show')
        page.should have_content('Edit')
        page.should have_content('Destroy')
      end
    end
  end
end
