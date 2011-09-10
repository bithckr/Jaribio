require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TestCasesController do

  # This should return the minimal set of attributes required to create a valid
  # Case. As you add validations to Case, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all cases as @test_cases" do
      test_case = TestCase.create! valid_attributes
      get :index
      assigns(:test_cases).should eq([test_case])
    end
  end

  describe "GET show" do
    it "assigns the requested case as @test_case" do
      test_case = TestCase.create! valid_attributes
      get :show, :id => test_case.id.to_s
      assigns(:test_case).should eq(test_case)
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
      test_case = TestCase.create! valid_attributes
      get :edit, :id => test_case.id.to_s
      assigns(:test_case).should eq(test_case)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TestCase" do
        expect {
          post :create, :test_case => valid_attributes
        }.to change(TestCase, :count).by(1)
      end

      it "assigns a newly created case as @case" do
        post :create, :test_case => valid_attributes
        assigns(:test_case).should be_a(TestCase)
        assigns(:test_case).should be_persisted
      end

      it "redirects to the created test_case" do
        post :create, :test_case => valid_attributes
        response.should redirect_to(TestCase.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved case as @test_case" do
        # Trigger the behavior that occurs when invalid params are submitted
        TestCase.any_instance.stub(:save).and_return(false)
        post :create, :test_case => {}
        assigns(:test_case).should be_a_new(TestCase)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TestCase.any_instance.stub(:save).and_return(false)
        post :create, :test_case => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested case" do
        test_case = TestCase.create! valid_attributes
        # Assuming there are no other cases in the database, this
        # specifies that the Case created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        TestCase.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => test_case.id, :test_case => {'these' => 'params'}
      end

      it "assigns the requested case as @case" do
        test_case = TestCase.create! valid_attributes
        put :update, :id => test_case.id, :test_case => valid_attributes
        assigns(:test_case).should eq(test_case)
      end

      it "redirects to the case" do
        test_case = TestCase.create! valid_attributes
        put :update, :id => test_case.id, :test_case => valid_attributes
        response.should redirect_to(test_case)
      end
    end

    describe "with invalid params" do
      it "assigns the case as @test_case" do
        test_case = TestCase.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TestCase.any_instance.stub(:save).and_return(false)
        put :update, :id => test_case.id.to_s, :test_case => {}
        assigns(:test_case).should eq(test_case)
      end

      it "re-renders the 'edit' template" do
        test_case = TestCase.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TestCase.any_instance.stub(:save).and_return(false)
        put :update, :id => test_case.id.to_s, :test_case => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested case" do
      test_case = TestCase.create! valid_attributes
      expect {
        delete :destroy, :id => test_case.id.to_s
      }.to change(TestCase, :count).by(-1)
    end

    it "redirects to the cases list" do
      test_case = TestCase.create! valid_attributes
      delete :destroy, :id => test_case.id.to_s
      response.should redirect_to(test_cases_url)
    end
  end

end
