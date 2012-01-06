require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe SuitesController do
  describe "routing" do

    it "routes to #index" do
      get("/suites").should route_to("suites#index")
    end

    it "routes to #new" do
      get("/suites/new").should route_to("suites#new")
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

    it "routes to #add_cases" do
      get("/suites/1/add_cases").should route_to("suites#add_cases", :id => "1")
    end

    it "routes to #sort" do
      post("/suites/1/sort").should route_to("suites#sort", :id => "1")
    end

    it "routes to #associate" do
      post("/suites/1/cases/1").should route_to("suites#associate", :id => "1", :case_id => "1")
    end

    it "routes to #unassociate" do
      delete("/suites/1/cases/1").should route_to("suites#unassociate", :id => "1", :case_id => "1")
    end
  end
end
