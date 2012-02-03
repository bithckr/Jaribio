require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

shared_examples "a form to create/edit a plan" do
  before(:each) do
    visit path
  end

  it "can enter plan 'Name'" do
    page.should have_field("plan_name")
  end

  it "has 'Save' button" do
    page.should have_button("Save")
  end

  it "has 'Cancel' link" do
    page.should have_link("Cancel")
  end
end

describe "Plans" do

  describe "GET /plans" do
    before(:each) do
      @user = login_any_user
      @plan = Factory.create(:plan)
    end

    it_behaves_like "a page with secondary navigation" do 
      let(:path) { plans_path }
    end

    describe "search" do
      before(:each) do
        visit plans_path
      end

      it "is supported" do
        page.should have_xpath("//div[@class='search']")
      end

      it "with results does include list of plans" do
        fill_in('q', :with => @plan.name)
        click_button('Search')
        page.should have_link('View')
        page.should have_link('Add Suites')
        page.should have_button('Delete')
      end

      it "with no results does not include list of plans" do
        fill_in('q', :with => 'asdf')
        click_button('Search')
        page.should have_no_link('View')
        page.should have_no_link('Add Suites')
        page.should have_no_button('Delete')
      end
    end

    describe "list" do
      before(:each) do
        visit plans_path
      end

      it "of plans" do
        page.should have_content(@plan.name)  
        page.should have_content(@plan.user.email)  
        page.should have_link('View')
        page.should have_link('Add Suites')
        page.should have_button('Close')
        page.should have_button('Delete')
      end

      it "clicking 'View' loads expected page" do
        click_link("View")
        current_path.should == plan_path(@plan)
      end

      it "clicking 'Add Suites' loads expected page" do
        click_link("Add Suites")
        current_path.should == add_suites_plan_path(@plan)
      end

      it "clicking 'Close' closes plan" do
         click_button("Close")
         @plan.reload
         @plan.closed_at.should_not be_nil
         page.should have_content('Successfully closed plan.')
         page.should_not have_link('Add Suites', :href => add_suites_plan_path(@plan))
         page.should_not have_link('Close', :href => close_plan_path(@plan))
      end
    end

  end

  describe "GET /plans/new" do
    before(:each) do 
      @user = login_any_user
    end

    it_behaves_like "a page with secondary navigation" do
      let(:path) { new_plan_path }
    end

    it_behaves_like "a form to create/edit a plan" do 
      let(:path) { new_plan_path }
    end

    it "creates a new plan when form is submitted" do
      visit new_plan_path
      fill_in('plan_name', :with => 'Plan A')
      click_button('Save')
      plan = Plan.where(:name => 'Plan A').first
      current_path.should == plan_path(plan)
    end

    it "shows the user an error message if no name is given" do
      visit new_plan_path
      click_button('Save')
      page.should have_content("Name can't be blank")
    end
  end

  describe "GET /plans/1" do
    before(:each) do
      @user = login_any_user
      @plan = Factory.create(:plan)
    end

    it_behaves_like "a page with secondary navigation" do 
      let(:path) { plan_path(@plan) }
    end

    it "should display 'Edit' link" do
      visit plan_path(@plan)
      page.should have_link('Edit')
    end

    it "should display plan name" do
      visit plan_path(@plan)
      page.should have_content(@plan.name)
    end

    it "clicking 'Edit' loads expected page" do
      visit plan_path(@plan)
      click_link('Edit')
      current_path.should == edit_plan_path(@plan)
    end

    describe "plan without associated suites" do
      before(:each) do
        visit plan_path(@plan)
      end

      it "should display plan name" do
        page.should have_content(@plan.name)
      end

      it "should not display suite list" do
        page.should_not have_content("Suite Name")
        page.should_not have_content("Suite Status")
      end
    end

    describe "plan with associated suites" do
      before(:each) do
        suites = []
        suites.push(Factory.create(:suite, :name => 'Suite A'))
        suites.push(Factory.create(:suite, :name => 'Suite B'))
        @plan.suites = suites
        @plan.save!
      end

      it "should display suite list" do
        visit plan_path(@plan)
        page.should have_content('Suite Name')
        page.should have_content('Suite Status')
        @plan.suites.each do |suite|
          page.should have_link(suite.name)
        end
      end

      it "should select the first suite in the list" do
        visit plan_path(@plan)
        element = page.find("#suite_#{@plan.suites.first.id}")
        element[:class].should =~ /selected/
      end

      it "should display the suite names alphabetically"

      describe "with cases" do
        before(:each) do
          @plan.suites.each do |suite|
            5.times do
              test_case = Factory.create(:test_case, :suites => [suite])
              test_case.save
            end
          end
          visit plan_path(@plan)
        end
        it "should have a link for each test case name" do
          @plan.suites.first.test_cases.each do |test_case|
            page.should have_link(test_case.name)
          end
        end
        it "should have a pass and fail radio button for each case" do
          @plan.suites.first.test_cases.each do |test_case|
            within("div#case_" + test_case.id.to_s) do
              page.has_field?('execution_status_code_1')
              page.has_field?('execution_status_code_2')
            end
          end
        end
        it "should have a 'Re-Test' button" do
          @plan.suites.first.test_cases.each do |test_case|
            within("div#case_" + test_case.id.to_s) do
              page.has_button?('Re-Test')
            end
          end
        end
        it "should have a disabled 'Re-Test' button if the case has no status" do
          @plan.suites.first.test_cases.each do |test_case|
            within("div#case_" + test_case.id.to_s) do
              page.find("button")['disabled'].should == 'disabled'
            end
          end
        end
        it "should not have a 'Re-Test' button if the plan is closed" do
          @plan.closed_at = Time.now + 1.second
          @plan.save
          visit plan_path(@plan)
          @plan.suites.first.test_cases.each do |test_case|
            within("div#case_" + test_case.id.to_s) do
              page.has_no_button?('Re-Test')
            end
          end
        end
        it "should display plan status" do
          visit plan_path(@plan)
          page.should have_xpath("//div[@id='plan_status']")
          page.should have_xpath("//div[@id='ps_unknowns']")
          find("#ps_unknowns")['title'].should == "Not executed: 10"
        end
        it "should have enabled pass/fail radio buttons if the case has no status"
        it "should have an enabled 'Re-Test' button if the case has a status"
        it "should have disabled pass/fail radio buttons if the case has a status"
        it "should display the test case list in the expected order"
      end

      describe "without cases" do
        it "should not display a test case list"
      end
    end
  end

  describe "GET /plans/1/edit" do
    before(:each) do
      @user = login_any_user
      @plan = Factory.create(:plan)
    end

    it_behaves_like "a page with secondary navigation" do
      let(:path) { edit_plan_path(@plan) }
    end

    it_behaves_like "a form to create/edit a plan" do 
      let(:path) { edit_plan_path(@plan) }
    end

    describe "current suite list" do
      it "is empty if no suites are associated to the plan" do
        visit edit_plan_path(@plan)
        page.should_not have_link('Unassociate')
      end

      it "is displayed if suites are associated to the plan" do
        @suite = Factory.create(:suite)
        @plan.suites = [@suite]
        @plan.save!
        visit edit_plan_path(@plan)
        page.should have_content('Current Suites')
        page.should have_link('Unassociate')
      end

      it "supports search through suite list"
    end
  end

  describe "GET /plans/1/add_suites" do
    before(:each) do
      @user = login_any_user
      @plan = Factory.create(:plan)
    end

    it_behaves_like "a page with secondary navigation" do 
      let(:path) { url_for([:add_suites, @plan]) }
    end

    it "with no associated suites" do
      visit url_for([:add_suites, @plan])
      page.should have_content('Associate Suites')
      page.should have_no_button('Associate')
    end

    it "with existing associated suites" do
      @new_suites = [Factory.create(:suite)]
      visit url_for([:add_suites, @plan])
      page.should have_content('Associate Suites')
      page.should have_button('Associate')
    end
  end
end
