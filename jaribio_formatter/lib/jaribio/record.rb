require 'jaribio/plan'
require 'jaribio/test_case'
require 'cgi'

module Jaribio
  class Record
    PASS = 1
    FAIL = 2

    attr_accessor :key, :description, :state, :error, :output

    def initialize(args = {})
      self.key = args[:key] 
      self.description = args[:description]
      self.state = args[:state]
      self.error = args[:error]
      self.output = args[:output] || $stdout
    end

    def failed?
      self.state != PASS
    end

    def ==(other)
      (self.key == other.key and 
       self.description == other.description and 
       self.state == other.state)
    end

    def eql?(other)
      self == other
    end

    def save(plans = [])
      begin
        test_case = Jaribio::TestCase.find(CGI::escape(self.key))
      rescue ActiveResource::ResourceNotFound
        output.puts "# Test case #{self.key} not found"
        return
      end
      if (test_case.nil?)
        output.puts "# Test case #{self.key} not found"
        return
      end

      return unless test_case.attributes.has_key?(:plans)
      plan_ids = Hash[ test_case.plans.map { |x| [x.id, 1] } ]

      # Configured plans in this block
      plans.each do |plan|
        # verify test case is part of this plan
        next unless plan_ids.has_key?(plan.id)

        # create execution
        create_execution(test_case, plan)
      end

      # No configured plans, try to update any open plan for each test case
      if (plans.size == 0)
        test_case.plans.each do |plan|
          create_execution(test_case, plan)
        end
      end
    end

    private

    def create_execution(test_case, plan)
      return unless plan.open?
      execution = Jaribio::Execution.new(
        :status_code => self.state,
        :results => self.error
      )
      execution.prefix_options = {:plan_id => plan.id, :test_case_id => test_case.id}
      begin
        execution.save()
        output.puts "# Saving execution of #{test_case.unique_key} - #{test_case.name} for plan #{plan.id} - #{plan.name}"
      rescue Exception => e
        output.puts "# Error saving execution of #{test_case.unique_key} - #{test_case.name} for plan #{plan.id} - #{plan.name}: #{e.message}"
        output.puts e.backtrace
      end
      return execution
    end

  end
end
