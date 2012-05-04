require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "API Authentication" do
  controller do
    def create
      render :nothing => true
    end
  end

  it "should check whether to skip csrf protection" do
    controller.should_receive(:skip_csrf?).and_return(false)
    post :create
  end

  it "should not call verify_authenticity_token" do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = Factory.create(:user)
    user.confirm! 
    sign_in user
    # pretend it was token auth and call the callback manually
    controller.current_user.after_token_authentication
    @verified = false
    controller.stub(:verify_authenticity_token) do 
      @verified = true
    end
    controller.skip_csrf?.should be_true
    post :create
    @verified.should be_false
  end
end
