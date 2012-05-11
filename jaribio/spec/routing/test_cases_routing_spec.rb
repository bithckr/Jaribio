require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe TestCasesController do
  describe "routing" do

    it "routes to #index" do
      get("/cases").should route_to("test_cases#index")
    end

    it "routes to #show" do
      get("/cases/1").should route_to("test_cases#show", :id => "1")
    end

    it "routes to #new" do
      get("/cases/new").should route_to("test_cases#new")
    end

    it "routes to #edit" do
      get("/cases/1/edit").should route_to("test_cases#edit", :id => "1")
    end

    it "routes to #executions" do
      get("/cases/1/executions").should route_to("test_cases#executions", :id => "1")
    end

    it "routes to #create" do
      post("/cases").should route_to("test_cases#create")
    end

    it "routes to #update" do
      put("/cases/1").should route_to("test_cases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/cases/1").should route_to("test_cases#destroy", :id => "1")
    end

  end
end
