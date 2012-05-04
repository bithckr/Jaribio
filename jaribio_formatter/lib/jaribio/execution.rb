require 'jaribio/plan'
require 'jaribio/test_case'
require 'cgi'

module Jaribio
  class Execution < RemoteObject
    self.prefix = '/plans/:plan_id/cases/:test_case_id/'

    def self.record_results(records, plans = [])
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

        next unless test_case.attributes.has_key?(:plans)
        plan_ids = Hash[ test_case.plans.map { |x| [x.id, 1] } ]

        # Configured plans in this block
        plans.each do |plan|
          # verify test case is part of this plan
          next unless plan_ids.has_key?(plan.id)

          # create execution
          create_execution(record, test_case, plan)
        end

        # No configured plans, try to update any open plan for each test case
        if (plans.size == 0)
          test_case.plans.each do |plan|
            create_execution(record, test_case, plan)
          end
        end
      end
    end

    def self.create_execution(record, test_case, plan)
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
      execution
    end

  end
end
