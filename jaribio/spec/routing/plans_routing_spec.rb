require "spec_helper"

describe PlansController do
  describe "routing" do

    it "routes to #index" do
      get("/plans").should route_to("plans#index")
    end

    it "routes to #new" do
      get("/plans/new").should route_to("plans#new")
    end

    it "routes to #show" do
      get("/plans/1").should route_to("plans#show", :id => "1")
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

  end
end
