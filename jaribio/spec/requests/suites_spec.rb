require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Suites" do

  describe "GET /suites" do
    before(:each) do
      @user = login_any_user
      @suite = Factory.create(:suite)
    end

    it_behaves_like "a page with secondary navigation" do
      let(:path) { suites_path }
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
        page.should have_link('Edit')
        page.should have_button('Delete')
      end

      it "with no results does not include list of suites" do
        fill_in('q', :with => 'asdf')
        click_button('Search')
        page.should have_no_link('Edit')
        page.should have_no_button('Delete')
      end
    end

    describe "list" do
      before(:each) do
        visit suites_path
      end

      it "of suites" do
        page.should have_content(@suite.name)  
        page.should have_content(@suite.user.email)  
        page.should have_link('Edit')
        page.should have_button('Delete')
      end
    end
  end

  describe "GET /suites/1/edit" do
    before(:each) do
      @user = login_any_user
      @suite = Factory.build(:suite)
      4.times do 
        @suite.test_cases << Factory.build(:test_case)
      end
      @suite.save!
    end

    it_behaves_like "a page with secondary navigation" do
      let(:path) { edit_suite_path(@suite) }
    end

    describe "form input" do
      before(:each) do
        visit edit_suite_path(@suite)
      end

      it "supports editing 'Name'" do
        page.should have_field("suite_name")
      end

      it "has 'Save' button" do
        page.should have_button("Save")
      end

      it "has 'Cancel' link" do
        page.should have_link("Cancel")
      end
    end

    describe "current case list" do
      before(:each) do
        visit edit_suite_path(@suite)
      end

      it "displays 'Key'" do
        page.should have_content('Key')
        @suite.test_cases.each do |tc|
          page.should have_content(tc.unique_key)
        end
      end

      it "displays 'Name'" do
        page.should have_content('Name')
        @suite.test_cases.each do |tc|
          page.should have_content(tc.name)
        end
      end

      it "displays 'Created By'" do
        page.should have_content('Created By')
        @suite.test_cases.each do |tc|
          page.should have_content(tc.user.email)
        end
      end

      it "can be sorted"

      it "has 'Unassociate button" do
        page.should have_button("Unassociate")
      end
    end

  end

  describe "GET /suites/1/add_cases" do
    before(:each) do
      @user = login_any_user
      @suite = Factory.create(:suite)
    end

    it_behaves_like "a page with secondary navigation" do
      let(:path) { url_for([:add_cases, @suite]) }
    end

    it "with no associated test cases" do
      visit url_for([:add_cases, @suite])
      page.should have_content('Associate Cases')
      page.should have_no_button('Associate')
    end

    it "with existing associated test cases" do
      @new_cases = [Factory.create(:test_case)]
      visit url_for([:add_cases, @suite])
      page.should have_content('Associate Cases')
      page.should have_button('Associate')
    end
  end
  
  describe "POST /suites" do
    before(:each) do
      @user = login_any_user
    end

    it "redirects to suites#index" do
      @suite = Factory.build(:suite)
      visit url_for(:action => 'new', :controller => :suites)
      fill_in(:name, :with => @suite.name)
      click_button('Save')

      page.status_code.should eql(200)
      page.current_url.should eql(url_for(:action => 'index', :controller => 'suites'))
      page.should have_content('Successfully created suite.')
    end
  end

  describe "PUT /suites" do
    before(:each) do
      @user = login_any_user
    end

    it "redirects to suites#index" do
      @suite = Factory.create(:suite)
      visit url_for([:edit, @suite])
      fill_in(:name, :with => 'Example Test Name')
      click_button('Save')

      page.status_code.should eql(200)
      page.current_url.should eql(url_for(:action => 'index', :controller => 'suites'))
      page.should have_content('Successfully updated suite.')
    end
  end
end
