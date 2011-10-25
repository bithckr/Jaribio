require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExecutionsController do
  login_user

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "GET show" do
    it "assigns the requested execution as @execution" do
      execution = Factory.create :execution
      get :show, :id => execution.id.to_s
      assigns(:execution).should eq(execution)
    end
  end

end
