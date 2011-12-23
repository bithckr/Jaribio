require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TestCasesController do
  login_user

  describe "GET index" do
    it "assigns all cases as @test_cases" do
      test_case = Factory.create(:test_case)
      get :index
      assigns(:test_cases).should eq([test_case])
    end
  end

  describe "GET new" do
    it "assigns a new case as @test_case" do
      get :new
      assigns(:test_case).should be_a_new(TestCase)
    end
  end

  describe "GET edit" do
    it "assigns the requested case as @test_case" do
      test_case = Factory.create(:test_case)
      get :edit, :id => test_case.id.to_s
      assigns(:test_case).should eq(test_case)
    end
  end

  describe "GET executions" do
    it "assigns the requested case as @test_case" do
      test_case = Factory.create(:test_case)
      get :executions, :id => test_case.id.to_s
      assigns(:test_case).should eq(test_case)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TestCase" do
        expect {
          post :create, :test_case => Factory.attributes_for(:test_case)
        }.to change(TestCase, :count).by(1)
      end

      it "assigns a newly created case as @case" do
        post :create, :test_case => Factory.attributes_for(:test_case)
        assigns(:test_case).should be_a(TestCase)
        assigns(:test_case).should be_persisted
      end

      it "redirects to edit test_case" do
        post :create, :test_case => Factory.attributes_for(:test_case)
        response.should redirect_to(edit_test_case_path(TestCase.last))
      end
    end

    describe "with invalid params" do
      before (:each) do 
        # Trigger the behavior that occurs when invalid params are submitted
        TestCase.any_instance.stub(:save).and_return(false)
        TestCase.any_instance.stub(:errors).and_return({ :anything => "any value (even nil)" })
      end

      it "assigns a newly created but unsaved case as @test_case" do
        post :create, :test_case => {}
        assigns(:test_case).should be_a_new(TestCase)
      end

      it "re-renders the 'new' template" do
        post :create, :test_case => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested case" do
        test_case = Factory.create(:test_case)
        # Assuming there are no other cases in the database, this
        # specifies that the Case created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        TestCase.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => test_case.id, :test_case => {'these' => 'params'}
      end

      it "assigns the requested case as @case" do
        test_case = Factory.create(:test_case)
        put :update, :id => test_case.id, :test_case => Factory.attributes_for(:test_case)
        assigns(:test_case).should eq(test_case)
      end

      it "redirects to the case" do
        test_case = Factory.create(:test_case)
        put :update, :id => test_case.id, :test_case => Factory.attributes_for(:test_case)
        response.should redirect_to(test_cases_url)
      end
    end

    describe "with invalid params" do

      before (:each) do 
        @test_case = Factory.create(:test_case)
        # Trigger the behavior that occurs when invalid params are submitted
        TestCase.any_instance.stub(:save).and_return(false)
        TestCase.any_instance.stub(:errors).and_return({ :anything => "any value (even nil)" })
      end

      it "assigns the case as @test_case" do
        put :update, :id => @test_case.id.to_s, :test_case => {}
        assigns(:test_case).should eq(@test_case)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => @test_case.id.to_s, :test_case => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested case" do
      test_case = Factory.create(:test_case)
      expect {
        delete :destroy, :id => test_case.id.to_s
      }.to change(TestCase, :count).by(-1)
    end

    it "redirects to the cases list" do
      test_case = Factory.create(:test_case)
      delete :destroy, :id => test_case.id.to_s
      response.should redirect_to(test_cases_url)
    end
  end

end
