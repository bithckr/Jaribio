require 'spec_helper'

describe StepsController do
  login_user

  it "should have a current_user" do
    subject.current_user.should_not be_nil
  end
  before(:each) do
    @test_case = Factory.create :test_case
  end

  describe "GET index" do
    it "assigns all steps as @steps" do
      step = Factory.create :step
      get :index
      assigns(:steps).should eq([step])
    end
  end

  describe "GET show" do
    it "assigns the requested step as @step" do
      step = Factory.create :step
      get :show, :id => step.id
      assigns(:step).should eq(step)
    end
  end

  describe "GET new" do
    it "assigns a new step as @step" do
      get :new, :test_case_id => @test_case.id
      assigns(:step).should be_a_new(Step)
    end
  end

  describe "GET edit" do
    it "assigns the requested step as @step" do
      step = Factory.create :step
      get :edit, :id => step.id, :test_case_id => @test_case.id
      assigns(:step).should eq(step)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Step" do
        expect {
          post :create, :step => Factory.attributes_for(:step), :test_case_id => @test_case.id
        }.to change(Step, :count).by(1)
      end

      it "assigns a newly created step as @step" do
        post :create, :step => Factory.attributes_for(:step), :test_case_id => @test_case.id
        assigns(:step).should be_a(Step)
        assigns(:step).should be_persisted
      end

      it "redirects to the created step" do
        post :create, :step => Factory.attributes_for(:step), :test_case_id => @test_case.id
        response.should redirect_to(Step.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved step as @step" do
        # Trigger the behavior that occurs when invalid params are submitted
        Step.any_instance.stub(:save).and_return(false)
        post :create, :step => {}, :test_case_id => @test_case.id
        assigns(:step).should be_a_new(Step)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Step.any_instance.stub(:save).and_return(false)
        Step.any_instance.stub(:errors).and_return({ :anything => "any value (even nil)" })
        post :create, :step => {}, :test_case_id => @test_case.id
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested step" do
        step = Factory.create :step
        # Assuming there are no other steps in the database, this
        # specifies that the Step created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Step.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => step.id, :test_case_id => @test_case.id, :step => {'these' => 'params'}
      end

      it "assigns the requested step as @step" do
        step = Factory.create :step
        put :update, :id => step.id.to_s, :test_case_id => @test_case.id, :step => Factory.attributes_for(:step)
        assigns(:step).should eq(step)
      end

      it "redirects to the step" do
        step = Factory.create :step
        put :update, :id => step.id.to_s, :test_case_id => @test_case.id, :step => Factory.attributes_for(:step)
        response.should redirect_to(step)
      end
    end

    describe "with invalid params" do
      it "assigns the step as @step" do
        step = Factory.create :step
        # Trigger the behavior that occurs when invalid params are submitted
        Step.any_instance.stub(:save).and_return(false)
        put :update, :id => step.id, :test_case_id => @test_case.id, :step => {}
        assigns(:step).should eq(step)
      end

      it "re-renders the 'edit' template" do
        step = Factory.create :step
        # Trigger the behavior that occurs when invalid params are submitted
        Step.any_instance.stub(:save).and_return(false)
        Step.any_instance.stub(:errors).and_return({ :anything => "any value (even nil)" })
        put :update, :id => step.id, :test_case_id => @test_case.id, :step => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested step" do
      step = Factory.create :step
      expect {
        delete :destroy, :id => step.id
      }.to change(Step, :count).by(-1)
    end

    it "redirects to the steps list" do
      step = Factory.create :step
      delete :destroy, :id => step.id
      response.should redirect_to(steps_url)
    end
  end

end
