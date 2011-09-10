require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SuitesController do

  # This should return the minimal set of attributes required to create a valid
  # Suite. As you add validations to Suite, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all suites as @suites" do
      suite = Suite.create! valid_attributes
      get :index
      assigns(:suites).should eq([suite])
    end
  end

  describe "GET show" do
    it "assigns the requested suite as @suite" do
      suite = Suite.create! valid_attributes
      get :show, :id => suite.id.to_s
      assigns(:suite).should eq(suite)
    end
  end

  describe "GET new" do
    it "assigns a new suite as @suite" do
      get :new
      assigns(:suite).should be_a_new(Suite)
    end
  end

  describe "GET edit" do
    it "assigns the requested suite as @suite" do
      suite = Suite.create! valid_attributes
      get :edit, :id => suite.id.to_s
      assigns(:suite).should eq(suite)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Suite" do
        expect {
          post :create, :suite => valid_attributes
        }.to change(Suite, :count).by(1)
      end

      it "assigns a newly created suite as @suite" do
        post :create, :suite => valid_attributes
        assigns(:suite).should be_a(Suite)
        assigns(:suite).should be_persisted
      end

      it "redirects to the created suite" do
        post :create, :suite => valid_attributes
        response.should redirect_to(Suite.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved suite as @suite" do
        # Trigger the behavior that occurs when invalid params are submitted
        Suite.any_instance.stub(:save).and_return(false)
        post :create, :suite => {}
        assigns(:suite).should be_a_new(Suite)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Suite.any_instance.stub(:save).and_return(false)
        post :create, :suite => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested suite" do
        suite = Suite.create! valid_attributes
        # Assuming there are no other suites in the database, this
        # specifies that the Suite created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Suite.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => suite.id, :suite => {'these' => 'params'}
      end

      it "assigns the requested suite as @suite" do
        suite = Suite.create! valid_attributes
        put :update, :id => suite.id, :suite => valid_attributes
        assigns(:suite).should eq(suite)
      end

      it "redirects to the suite" do
        suite = Suite.create! valid_attributes
        put :update, :id => suite.id, :suite => valid_attributes
        response.should redirect_to(suite)
      end
    end

    describe "with invalid params" do
      it "assigns the suite as @suite" do
        suite = Suite.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Suite.any_instance.stub(:save).and_return(false)
        put :update, :id => suite.id.to_s, :suite => {}
        assigns(:suite).should eq(suite)
      end

      it "re-renders the 'edit' template" do
        suite = Suite.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Suite.any_instance.stub(:save).and_return(false)
        put :update, :id => suite.id.to_s, :suite => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested suite" do
      suite = Suite.create! valid_attributes
      expect {
        delete :destroy, :id => suite.id.to_s
      }.to change(Suite, :count).by(-1)
    end

    it "redirects to the suites list" do
      suite = Suite.create! valid_attributes
      delete :destroy, :id => suite.id.to_s
      response.should redirect_to(suites_url)
    end
  end

end
