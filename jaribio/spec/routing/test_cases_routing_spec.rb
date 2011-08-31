require "spec_helper"

describe TestCasesController do
  describe "routing" do

    it "routes to #index" do
      get("/test_cases").should route_to("test_cases#index")
    end

    it "routes to #new" do
      get("/test_cases/new").should route_to("test_cases#new")
    end

    it "routes to #show" do
      get("/test_cases/1").should route_to("test_cases#show", :id => "1")
    end

    it "routes to #edit" do
      get("/test_cases/1/edit").should route_to("test_cases#edit", :id => "1")
    end

    it "routes to #create" do
      post("/test_cases").should route_to("test_cases#create")
    end

    it "routes to #update" do
      put("/test_cases/1").should route_to("test_cases#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/test_cases/1").should route_to("test_cases#destroy", :id => "1")
    end

  end
end
