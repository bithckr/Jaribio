require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PlansController do

  # This should return the minimal set of attributes required to create a valid
  # Plan. As you add validations to Plan, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all plans as @plans" do
      plan = Plan.create! valid_attributes
      get :index
      assigns(:plans).should eq([plan])
    end
  end

  describe "GET show" do
    it "assigns the requested plan as @plan" do
      plan = Plan.create! valid_attributes
      get :show, :id => plan.id.to_s
      assigns(:plan).should eq(plan)
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
      plan = Plan.create! valid_attributes
      get :edit, :id => plan.id.to_s
      assigns(:plan).should eq(plan)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Plan" do
        expect {
          post :create, :plan => valid_attributes
        }.to change(Plan, :count).by(1)
      end

      it "assigns a newly created plan as @plan" do
        post :create, :plan => valid_attributes
        assigns(:plan).should be_a(Plan)
        assigns(:plan).should be_persisted
      end

      it "redirects to the created plan" do
        post :create, :plan => valid_attributes
        response.should redirect_to(Plan.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved plan as @plan" do
        # Trigger the behavior that occurs when invalid params are submitted
        Plan.any_instance.stub(:save).and_return(false)
        post :create, :plan => {}
        assigns(:plan).should be_a_new(Plan)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Plan.any_instance.stub(:save).and_return(false)
        post :create, :plan => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested plan" do
        plan = Plan.create! valid_attributes
        # Assuming there are no other plans in the database, this
        # specifies that the Plan created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Plan.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => plan.id, :plan => {'these' => 'params'}
      end

      it "assigns the requested plan as @plan" do
        plan = Plan.create! valid_attributes
        put :update, :id => plan.id, :plan => valid_attributes
        assigns(:plan).should eq(plan)
      end

      it "redirects to the plan" do
        plan = Plan.create! valid_attributes
        put :update, :id => plan.id, :plan => valid_attributes
        response.should redirect_to(plan)
      end
    end

    describe "with invalid params" do
      it "assigns the plan as @plan" do
        plan = Plan.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Plan.any_instance.stub(:save).and_return(false)
        put :update, :id => plan.id.to_s, :plan => {}
        assigns(:plan).should eq(plan)
      end

      it "re-renders the 'edit' template" do
        plan = Plan.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Plan.any_instance.stub(:save).and_return(false)
        put :update, :id => plan.id.to_s, :plan => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested plan" do
      plan = Plan.create! valid_attributes
      expect {
        delete :destroy, :id => plan.id.to_s
      }.to change(Plan, :count).by(-1)
    end

    it "redirects to the plans list" do
      plan = Plan.create! valid_attributes
      delete :destroy, :id => plan.id.to_s
      response.should redirect_to(plans_url)
    end
  end

end
