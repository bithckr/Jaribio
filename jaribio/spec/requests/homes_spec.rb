require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Home" do
  describe "GET /home" do
    it "works! (now write some real specs)" do
      get homes_path
      response.status.should be(200)
    end
  end
end
