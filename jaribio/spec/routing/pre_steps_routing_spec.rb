require "spec_helper"

describe PreStepsController do
  describe "routing" do

    it "routes to #index" do
      get("/pre_steps").should route_to("pre_steps#index")
    end

    it "routes to #new" do
      get("/pre_steps/new").should route_to("pre_steps#new")
    end

    it "routes to #show" do
      get("/pre_steps/1").should route_to("pre_steps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/pre_steps/1/edit").should route_to("pre_steps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/pre_steps").should route_to("pre_steps#create")
    end

    it "routes to #update" do
      put("/pre_steps/1").should route_to("pre_steps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/pre_steps/1").should route_to("pre_steps#destroy", :id => "1")
    end

  end
end
