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
        page.should have_button('Delete')
      end

      it "with no results does not include list of plans" do
        fill_in('q', :with => 'asdf')
        click_button('Search')
        page.should have_no_link('Edit')
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
        page.should have_button('Delete')
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

  end

  describe "GET /plans/1" do
    before(:each) do
      @user = login_any_user
      @plan = Factory.create(:plan)
    end

    it_behaves_like "a page with secondary navigation" do 
      let(:path) { plan_path(@plan) }
    end

    describe "show" do
      before(:each) do
        visit plan_path(@plan)
      end

      it "should display without associated suites" do
        page.should have_content(@plan.name)
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
