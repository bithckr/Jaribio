require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Executions" do

  describe "GET /executions" do
    before(:each) do
      @user = login_any_user
      @execution = Factory.create(:execution)
    end

    describe "show" do
      before(:each) do
        visit url_for(:controller => "executions", :action => "show", :id => @execution)
      end

      it "has execution info" do
        page.should have_content(@execution.user.email)
        page.should have_content(@execution.test_case.name)
        page.should have_content('<<Back')
      end
    end

  end
end
