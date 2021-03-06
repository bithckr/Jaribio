require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe PlansController do
  describe "routing" do

    it "routes to #index" do
      get("/plans").should route_to("plans#index")
    end

    it "routes to #open" do
      get("plans/open").should route_to("plans#open")
    end

    it "routes to #new" do
      get("/plans/new").should route_to("plans#new")
    end

    it "routes to #edit" do
      get("/plans/1/edit").should route_to("plans#edit", :id => "1")
    end

    it "routes to #create" do
      post("/plans").should route_to("plans#create")
    end

    it "routes to #update" do
      put("/plans/1").should route_to("plans#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/plans/1").should route_to("plans#destroy", :id => "1")
    end

    it "routes to #add_suites" do
      get("/plans/1/add_suites").should route_to("plans#add_suites", :id => "1")
    end

    it "routes to #associate" do
      post("/plans/1/suites/1").should route_to("plans#associate", :id => "1", :suite_id => "1")
    end

    it "routes to #unassociate" do
      delete("/plans/1/suites/1").should route_to("plans#unassociate", :id => "1", :suite_id => "1")
    end

    it "routes to #close" do
      post("/plans/1/close").should route_to("plans#close", :id => "1")
    end

    it "routes to #open" do
      post("/plans/1/open").should route_to("plans#open", :id => "1")
    end

  end
end
