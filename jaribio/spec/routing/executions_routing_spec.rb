require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe ExecutionsController do
  describe "routing" do

    it "routes to #show" do
      get("/executions/1").should route_to("executions#show", :id => "1")
    end

  end
end
