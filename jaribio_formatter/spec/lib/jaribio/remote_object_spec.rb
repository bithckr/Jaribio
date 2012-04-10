require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Jaribio::RemoteObject" do
  before do
    RSpec.configure do |c|
      c.jaribio_api_key = 'asdf1234'
      c.jaribio_url = 'http://localhost'
    end
    Jaribio::RemoteObject.configure(RSpec.configuration)
  end

  describe "#query_string" do
    it "automatically adds the api_key as a query parameter to requests" do
      Jaribio::RemoteObject.element_path(1).should == '/remote_objects/1.json?api_key=asdf1234'
    end
  end

  describe "#configure" do

    it "jaribio url" do 
      Jaribio::RemoteObject.site.to_s.should == RSpec.configuration.jaribio_url
    end

    it "jaribio api key" do
      Jaribio::RemoteObject.api_key.should == RSpec.configuration.jaribio_api_key
    end

    it "jaribio timeout" do
      Jaribio::RemoteObject.timeout.should == RSpec.configuration.jaribio_timeout
    end

  end

end
