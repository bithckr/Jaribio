require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TokenAuthenticationsController do
  login_user

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "POST create" do
    it "resets the authentication token" do
      subject.current_user.should_receive(:reset_authentication_token!)
      post :create
    end

    it "redirects to the edit_user_registration page" do
      post :create
      response.should redirect_to(edit_user_registration_url(subject.current_user))
    end
  end

  describe "DELETE destroy" do
    it "destroys the authentication token" do
      delete :destroy
      subject.current_user.reload
      subject.current_user.authentication_token.should be_nil
    end

    it "redirects to the edit_user_registration page" do
      delete :destroy
      response.should redirect_to(edit_user_registration_url(subject.current_user))
    end
  end

end
