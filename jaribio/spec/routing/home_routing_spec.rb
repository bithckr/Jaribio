require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe HomeController do
  describe "routing" do

    it "routes root to #index" do
      get("/").should route_to("home#index")
    end

    it "routes to #index" do
      get("/home").should route_to("home#index")
    end

  end
end
