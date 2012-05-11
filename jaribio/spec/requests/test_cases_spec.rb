require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "TestCases" do

  describe "GET /cases" do
    before(:each) do
      @user = login_any_user
      @test_case = Factory.create(:test_case)
    end

    it_behaves_like "a page with secondary navigation" do
      let(:path) { test_cases_path }
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
        page.should have_link('View')
        page.should have_button('Delete')
      end

      it "with no results does not include list of cases" do
        fill_in('q', :with => 'asdf')
        click_button('Search')
        page.should have_no_link('View')
        page.should have_no_button('Delete')
      end
    end

    describe "list" do
      it "of test cases" do
        visit test_cases_path
        page.should have_content(@test_case.name)  
        page.should have_content(@test_case.user.email)  
        page.should have_link('View')
        page.should have_link('History')
        page.should have_button('Copy')
        page.should have_button('Delete')
      end

      it "supports pagination" do
        11.times do 
          Factory.create(:test_case)
        end
        visit test_cases_path
        page.should have_xpath("//nav")
      end

      it "allows test case to be copied" do
        page.reset_session!
        @new_user = login_any_user
        visit test_cases_path
        click_button('Copy')
        find("#test_case_unique_key")['value'].should_not == @test_case.unique_key
        click_link('Cancel')
        page.should have_content(@new_user.email)
      end
    end

    describe "history" do
      it "has passing executions" do
        execution = Factory.build(:execution, :test_case => @test_case)
        @test_case.executions << execution
        visit url_for([:executions, @test_case])
        page.should have_content(@test_case.name)
        page.should have_content('PASS')
        page.should have_link('View')
      end

      it "has failing executions" do
        execution = Factory.build(:execution, 
                                  :test_case => @test_case, 
                                  :status_code => Status::FAIL)
        @test_case.executions << execution
        visit url_for([:executions, @test_case])
        page.should have_content('FAIL')
      end

      it "supports pagination" do
        plan = Factory.build(:plan)
        11.times do
          execution = Factory.build(:execution, 
                                    :test_case => @test_case, 
                                    :plan => plan, 
                                    :status_code => Status::PASS)
          @test_case.executions << execution
        end
        visit url_for([:executions, @test_case])
        page.should have_xpath("//nav")
      end

    end
  end

  describe "GET /cases/1" do
    before(:each) do
      @user = login_any_user
      @test_case = Factory.build(:test_case)
      @test_case.suites << Factory.build(:suite)
      @test_case.save!
    end

    it_behaves_like "a page with secondary navigation" do
      let(:path) { test_case_path(@test_case) }
    end

    describe "form input" do
      before(:each) do
        visit test_case_path(@test_case)
      end

      it "can see 'Name'" do
        page.should have_field("test_case_name")
      end

      it "has 'Edit' link" do
        page.should have_link("Edit")
      end

      it "has 'Cancel' link" do
        page.should have_link("Cancel")
      end
    end
  end

  describe "POST /cases" do
    before(:each) do
      @user = login_any_user
    end

    it "redirects to cases#edit" do
      @test_case = Factory.build(:test_case)
      visit url_for(:action => 'new', :controller => :test_cases)
      fill_in('test_case[name]', :with => @test_case.name)
      click_button('Save')

      page.status_code.should eql(200)
      page.current_url.should eql(edit_test_case_url(TestCase.last))
      page.should have_content('Successfully created test case.')
    end
  end

  describe "PUT /cases" do
    before(:each) do
      @user = login_any_user
    end

    it "redirects to cases#index" do
      @test_case = Factory.create(:test_case)
      visit url_for([:edit, @test_case])
      fill_in(:name, :with => 'Example Test Name')
      click_button('Save')

      page.status_code.should eql(200)
      page.current_url.should eql(url_for(:action => 'index', :controller => 'test_cases'))
      page.should have_content('Successfully updated test case.')
    end

    it "keeps original user assigned to test_case" do
      @test_case = Factory.create(:test_case)
      @orig_user = @test_case.user
      @user = login_any_user
      visit url_for([:edit, @test_case])
      fill_in(:name, :with => 'Example Test Name')
      click_button('Save')

      # I couldn't get capy to locate the ID because of a . in the name
      # not sure if that is a bug or not
      page.should have_content(@orig_user.email)
    end

    it "uses ajax to add Step", :js => true do
      @test_case = Factory.create(:test_case)
      @step = Factory.build(:step)
      visit url_for_selenium([:edit, @test_case])
      click_button('Add Step')
      page.should have_content('Add Test Case Step')
      fill_in('step_action', :with => @step.action)
      fill_in('step_results', :with => @step.results)
      click_button('Create Step')
      page.should have_content(@step.action)
      page.should have_content(@step.results)
    end
  end
end
