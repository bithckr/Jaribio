require "spec_helper"

describe StepsController do
  describe "routing" do

    it "routes to #index" do
      get("/steps").should route_to("steps#index")
    end

    it "routes to #new" do
      get("/steps/new").should route_to("steps#new")
    end

    it "routes to #show" do
      get("/steps/1").should route_to("steps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/steps/1/edit").should route_to("steps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/steps").should route_to("steps#create")
    end

    it "routes to #update" do
      put("/steps/1").should route_to("steps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/steps/1").should route_to("steps#destroy", :id => "1")
    end

  end
end
