require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TestCases" do

  describe "GET /cases" do
    before(:each) do
      @user = login_any_user
      @test_case = Factory.create(:test_case)
    end

    describe "secondary navigation" do
      before(:each) do
        visit test_cases_path
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
        visit test_cases_path
      end

      it "is supported" do
        page.should have_xpath("//div[@class='search']")
      end

      it "with results does include list of cases" do
        fill_in('q', :with => @test_case.name)
        click_button('Search')
        page.should have_content('Edit')
        page.should have_content('Delete')
      end

      it "with no results does not include list of cases" do
        fill_in('q', :with => 'asdf')
        click_button('Search')
        page.should have_no_content('Edit')
        page.should have_no_content('Delete')
      end
    end

    describe "list" do
      before(:each) do
        visit test_cases_path
      end

      it "of test cases" do
        page.should have_content(@test_case.name)  
        page.should have_content(@test_case.user.email)  
        page.should have_content('Edit')
        page.should have_content('History')
        page.should have_content('Delete')
      end
    end

    describe "history" do
      before(:each) do
        visit test_cases_path
      end

      it "has History" do
        click_link('History')
        page.should have_content(@test_case.name)
        page.should have_content('View')
      end
    end

  end
end
