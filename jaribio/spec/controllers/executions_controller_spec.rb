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

  describe "POST create" do
    before(:each) do
      @test_case = Factory.create(:test_case)
      @suite = Factory.create(:suite)
      @suite.test_cases = [@test_case]
      @plan = Factory.create(:plan)
      @plan.suites = [@suite]
    end

    describe "with valid params" do
      it "creates a new execution" do
        expect {
          post :create, :execution => Factory.attributes_for(:execution), :test_case_id => @test_case.id.to_s, :test_case_counter => 1, :suite_id => @suite.id.to_s, :plan_id => @plan.id.to_s
        }.to change(Execution, :count).by(1)
      end
    end
  end

end
