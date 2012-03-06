require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Jaribio::Record" do
  describe "#failed?" do
    it "is true when not set" do
      Jaribio::Record.new().failed?.should be_true
    end

    it "is true when state is FAIL" do
      Jaribio::Record.new(:state => Jaribio::Record::FAIL).failed?.should be_true
    end

    it "is false when state is PASS" do
      Jaribio::Record.new(:state => Jaribio::Record::PASS).failed?.should be_false
    end
  end

  describe "#eql?" do
    let(:attributes) { Hash.new(:key => 'key', :description => 'description', :state => Jaribio::Record::PASS) }

    it "true if attributes are eql?" do
      a = Jaribio::Record.new(attributes)
      b = Jaribio::Record.new(attributes)
      a.should eql(b)
    end
  end

end
