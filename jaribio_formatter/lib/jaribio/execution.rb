require 'jaribio/plan'
require 'jaribio/test_case'
require 'cgi'

module Jaribio
  class Execution < RemoteObject
    self.prefix = '/plans/:plan_id/cases/:test_case_id/'

    def self.record_results(records, plans = [])
      if plans.size == 0
        plans = Jaribio::Plan.find(:all, :from => :open)
      end

      records.each do |record|
        begin
          test_case = Jaribio::TestCase.find(CGI::escape(record.key))
        rescue ActiveResource::ResourceNotFound
          $stderr.puts "Test case #{record.key} not found"
          next
        end
        if (test_case.nil?)
          $stderr.puts "Test case #{record.key} not found"
          next
        end

        plans.each do |plan|
          execution = Jaribio::Execution.new(
            :status_code => record.state,
            :results => record.error
          )
          execution.prefix_options = {:plan_id => plan.id, :test_case_id => test_case.id}
          begin
            execution.save()
          rescue Exception => e
            $stderr.puts "Error saving execution of #{test_case.id} for plan #{plan.id}: #{e.message}"
          end
        end
      end
    end
  end
end
