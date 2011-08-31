require "spec_helper"

describe SuitesController do
  describe "routing" do

    it "routes to #index" do
      get("/suites").should route_to("suites#index")
    end

    it "routes to #new" do
      get("/suites/new").should route_to("suites#new")
    end

    it "routes to #show" do
      get("/suites/1").should route_to("suites#show", :id => "1")
    end

    it "routes to #edit" do
      get("/suites/1/edit").should route_to("suites#edit", :id => "1")
    end

    it "routes to #create" do
      post("/suites").should route_to("suites#create")
    end

    it "routes to #update" do
      put("/suites/1").should route_to("suites#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/suites/1").should route_to("suites#destroy", :id => "1")
    end

  end
end
