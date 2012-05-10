require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'stringio'
require 'cgi'

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

  describe "#save" do
    before do
      @plan = double("Jaribio::Plan", :id => 1, :name => "Plan 1")
      @execution = double("Jaribio::Execution")
      @stream = StringIO.new("", "w+")
      @record = Jaribio::Record.new(:key => 'key', :description => 'description', :state => Jaribio::Record::PASS, :output => @stream)
      @test_case = double("Jaribio::TestCase", :id => 1, :attributes => {:plans => 1},
                         :unique_key => @record.key, :name => @record.description)
      @test_case.stub(:plans).and_return([@plan])

      @execution.should_receive(:prefix_options=).with({:plan_id => @plan.id, :test_case_id => @test_case.id})
      @execution.should_receive(:save)
      Jaribio::TestCase.should_receive(:find).with(CGI::escape(@record.key)).and_return(@test_case)
    end

    it "creates executions for specified plans" do
      @plan.should_receive(:open?).and_return(true)
      Jaribio::Execution.should_receive(:new).with({:status_code => @record.state, :results => @record.error}).once.and_return(@execution)
      @record.save([@plan])
      @stream.string.should =~ /Saving execution/
    end

    it "creates new executions for open plans and existing test cases" do
      @plan.should_receive(:open?).and_return(true)
      Jaribio::Execution.should_receive(:new).with({:status_code => @record.state, :results => @record.error}).once.and_return(@execution)
      @record.save()
      @stream.string.should =~ /Saving execution/
    end
  end
end
