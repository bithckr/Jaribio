require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SuitesController do
  login_user

  describe "GET index" do
    it "assigns all suites as @suites" do
      suite = Factory.create(:suite)
      get :index
      assigns(:suites).should eq([suite])
    end
  end

  describe "GET show" do
    it "assigns the requested suite as @suite" do
      suite = Factory.create(:suite)
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
      suite = Factory.create(:suite)
      get :edit, :id => suite.id.to_s
      assigns(:suite).should eq(suite)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Suite" do
        expect {
          post :create, :suite => Factory.attributes_for(:suite)
        }.to change(Suite, :count).by(1)
      end

      it "assigns a newly created suite as @suite" do
        post :create, :suite => Factory.attributes_for(:suite)
        assigns(:suite).should be_a(Suite)
        assigns(:suite).should be_persisted
      end

      it "redirects to the created suite" do
        post :create, :suite => Factory.attributes_for(:suite)
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
        suite = Factory.create(:suite)
        # Assuming there are no other suites in the database, this
        # specifies that the Suite created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Suite.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => suite.id, :suite => {'these' => 'params'}
      end

      it "assigns the requested suite as @suite" do
        suite = Factory.create(:suite)
        put :update, :id => suite.id, :suite => Factory.attributes_for(:suite)
        assigns(:suite).should eq(suite)
      end

      it "redirects to the suite" do
        suite = Factory.create(:suite)
        put :update, :id => suite.id, :suite => Factory.attributes_for(:suite)
        response.should redirect_to(suite)
      end
    end

    describe "with invalid params" do
      it "assigns the suite as @suite" do
        suite = Factory.create(:suite)
        # Trigger the behavior that occurs when invalid params are submitted
        Suite.any_instance.stub(:save).and_return(false)
        put :update, :id => suite.id.to_s, :suite => {}
        assigns(:suite).should eq(suite)
      end

      it "re-renders the 'edit' template" do
        suite = Factory.create(:suite)
        # Trigger the behavior that occurs when invalid params are submitted
        Suite.any_instance.stub(:save).and_return(false)
        put :update, :id => suite.id.to_s, :suite => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested suite" do
      suite = Factory.create(:suite)
      expect {
        delete :destroy, :id => suite.id.to_s
      }.to change(Suite, :count).by(-1)
    end

    it "redirects to the suites list" do
      suite = Factory.create(:suite)
      delete :destroy, :id => suite.id.to_s
      response.should redirect_to(suites_url)
    end
  end

end
