require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlansController do
  login_user

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end

  describe "GET index" do
    it "assigns all plans as @plans" do
      plan = Factory.create :plan
      get :index
      assigns(:plans).should eq([plan])
    end
  end

  describe "GET open" do
    it "assigns open plans as @plans" do
      plan = Factory.create :plan
      get :open, :format => :json
      assigns(:plans).should eq([plan])
    end
  end

  describe "GET new" do
    it "assigns a new plan as @plan" do
      get :new
      assigns(:plan).should be_a_new(Plan)
    end
  end

  describe "GET edit" do
    it "assigns the requested plan as @plan" do
      plan = Factory.create :plan
      get :edit, :id => plan.id.to_s
      assigns(:plan).should eq(plan)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Plan" do
        expect {
          post :create, :plan => Factory.attributes_for(:plan)
        }.to change(Plan, :count).by(1)
      end

      it "assigns a newly created plan as @plan" do
        post :create, :plan => Factory.attributes_for(:plan)
        assigns(:plan).should be_a(Plan)
        assigns(:plan).should be_persisted
      end

      it "redirects to the created plan" do
        post :create, :plan => Factory.attributes_for(:plan)
        response.should redirect_to(Plan.last)
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        Plan.any_instance.stub(:save).and_return(false)
        Plan.any_instance.stub(:errors).and_return({ :anything => "any value (even nil)" })
      end

      it "assigns a newly created but unsaved plan as @plan" do
        post :create, :plan => {}
        assigns(:plan).should be_a_new(Plan)
      end

      it "re-renders the 'new' template" do
        post :create, :plan => {}
        response.should render_template("new")
      end
    end
  end

  describe "POST associate" do
    before(:each) do
      @plan = Factory.create(:plan)
      @suite = Factory.create(:suite)
    end

    it "adds suite to plan" do
      expect {
        post :associate, :id => @plan.id.to_s, :suite_id => @suite.id.to_s
      }.to change(@plan.suites, :count).by(+1)
    end

    it "redirects to the plans suites" do
      post :associate, :id => @plan.id.to_s, :suite_id => @suite.id.to_s
      response.should redirect_to(add_suites_plan_path)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested plan" do
        plan = Factory.create(:plan)
        # Assuming there are no other plans in the database, this
        # specifies that the Plan created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Plan.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => plan.id, :plan => {'these' => 'params'}
      end

      it "assigns the requested plan as @plan" do
        plan = Factory.create(:plan)
        put :update, :id => plan.id, :plan => Factory.attributes_for(:plan)
        assigns(:plan).should eq(plan)
      end

      it "redirects to the plan" do
        plan = Factory.create(:plan)
        put :update, :id => plan.id, :plan => Factory.attributes_for(:plan)
        response.should redirect_to(plan)
      end
    end

    describe "with invalid params" do
      before(:each) do
        @plan = Factory.create(:plan)
        # Trigger the behavior that occurs when invalid params are submitted
        Plan.any_instance.stub(:save).and_return(false)
        Plan.any_instance.stub(:errors).and_return({ :anything => "any value (even nil)" })
      end

      it "assigns the plan as @plan" do
        put :update, :id => @plan.id.to_s, :plan => {}
        assigns(:plan).should eq(@plan)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => @plan.id.to_s, :plan => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE unassociate" do
    before(:each) do
      @plan = Factory.create(:plan)
      @suite = Factory.create(:suite)
      @plan.suites << @suite
    end

    it "removes suite from plan" do
      expect {
        delete :unassociate, :id => @plan.id.to_s, :suite_id => @suite.id.to_s
      }.to change(@plan.suites, :count).by(-1)
    end

    it "redirects to the plans edit" do
      delete :unassociate, :id => @plan.id.to_s, :suite_id => @suite.id.to_s
      response.should redirect_to(edit_plan_path)
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested plan" do
      plan = Factory.create(:plan)
      expect {
        delete :destroy, :id => plan.id.to_s
      }.to change(Plan, :count).by(-1)
    end

    it "redirects to the plans list" do
      plan = Factory.create(:plan)
      delete :destroy, :id => plan.id.to_s
      response.should redirect_to(plans_url)
    end
  end

  describe "POST close" do
    it "sets closed_at to now" do
      plan = Factory.create(:plan)
      plan.closed_at.should be_nil
      post :close, :id => plan.id.to_s
      plan.reload
      plan.closed_at.should_not be_nil
    end
  end

  describe "POST open" do
    it "sets closed_at to nil" do
      plan = Factory.create(:plan, :closed_at => Time.now)
      plan.closed_at.should_not be_nil
      post :open, :id => plan.id.to_s
      plan.reload
      plan.closed_at.should be_nil
    end
  end

  describe "POST copy" do
    before(:each) do
      @plan = Factory.build(:plan)
      4.times do
        @plan.suites << Factory.create(:suite)
      end
      @plan.save!
    end

    it "creates a copy of an existing plan" do
      expect {
        post :copy, :id => @plan.id
      }.to change(Plan, :count).by(1)
    end

    it "has the same suites as the existing plan" do
      post :copy, :id => @plan.id
      new_plan = assigns(:plan)
      new_plan.suite_ids.sort.should == @plan.suite_ids.sort
    end
  end
end
