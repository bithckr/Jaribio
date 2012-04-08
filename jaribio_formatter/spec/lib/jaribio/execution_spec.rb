require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Jaribio::Execution" do
  describe "#record_results" do
    before do
      @plan = double("Jaribio::Plan", :id => 1)
      Jaribio::Plan.should_receive(:find).
        with(:all, { :from => :open }).
        and_return([@plan])
    end

    it "finds open plans" do
      Jaribio::Execution.record_results([])
    end

    it "creates new executions for open plans and existing test cases" do
      record = Jaribio::Record.new(:key => 'abcdef', :description => "description", :state => Jaribio::Record::PASS) 
      records = [record]
      test_case = double("Jaribio::TestCase", :id => 1)
      Jaribio::TestCase.should_receive(:find).with(record.key).and_return(test_case)
      execution = double("Jaribio::Execution")
      execution.should_receive(:save).with({:plan_id => @plan.id, :test_case_id => test_case.id})
      Jaribio::Execution.should_receive(:new).with({:status_code => record.state, :results => record.error}).and_return(execution)
      Jaribio::Execution.record_results(records)
    end
  end
end
