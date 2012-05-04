require 'jaribio/record'
require 'rspec/core'
require 'cgi'
require 'base64'
require 'digest/md5'

module Jaribio
  class RSpecFormatter

    attr_reader :output, :results, :example_group

    def initialize(output)
      @output = output || StringIO.new
      @results = {}
    end

    def start(example_count)
    end

    def example_group_started(example_group)
      @example_group = example_group
    end

    def example_group_finished(example_group)
    end

    def example_started(example)
    end

    # 
    # Mark example as passed via unique key
    #
    def example_passed(example)
      record_result(example)
    end

    def example_pending(example)
    end

    # 
    # Mark example as failed via unique key
    #
    def example_failed(example)
      record_result(example, true)
    end

    def message(message)
    end

    def stop
    end

    def start_dump()
    end

    def dump_pending()
    end

    def dump_failures()
    end

    def dump_summary(duration, example_count, failure_count, pending_count)
      results.each do |key, data|
        output.puts "Key: #{key}"
        output.puts "Desc: #{data.description}"
        output.puts "Failed: #{data.failed?.to_s}"
      end
    end

    # no-op
    def seed(seed)
    end

    # 
    # Update Jaribio
    # - configured to update pass/fail?
    # - configured to output a report (for the purpose of updating your specs)
    # - configured to generate plan/suite/test case?
    #
    def close()
      Jaribio::RemoteObject.configure(configuration)
      # create missing test cases, the new test cases are not automatically
      # added to any plan
      if RSpec.configuration.jaribio_auto_create
        results.values.each do |record|
          begin
            test_case = Jaribio::TestCase.find(CGI::escape(record.key))
          rescue ActiveResource::ResourceNotFound
          end
          if (test_case.nil?)
            test_case = Jaribio::TestCase.new(
              :name => record.description,
              :unique_key => record.key,
              :automated => true
            )
            begin
              test_case.save
            rescue Exception => e
              $stderr.puts "Error creating test case #{record.key}: #{e.message}"
            end
          end
        end
      end

      plans = []
      # create executions for specific plans only
      if RSpec.configuration.jaribio_plans.size > 0
        RSpec.configuration.jaribio_plans.each do |plan_id|
          begin
            plan = Jaribio::Plan.find(plan_id)
            if plan.open?
              plans << plan
            end
          rescue ActiveResource::ResourceNotFound
            $stderr.puts "RSpec configuration of jaribio_plans includes unknown plan_id #{plan_id}"
          end
        end
      end

      Jaribio::Execution.record_results(results.values, plans)
    end

    protected

    def configuration
      RSpec.configuration
    end

    def record_result(example, failed = false)
      key, desc = get_example_key(example)
      if (@results.has_key?(key))
        failed = failed || @results[key].failed?
      end
      error = nil
      if (example.execution_result.has_key?(:exception))
        exception = example.execution_result[:exception]
        unless (exception.nil?)
          error = "#{exception.message}\n#{exception.backtrace}"
        end
      end
      record = Record.new(:key => key, :description => desc, :state => failed ? Jaribio::Record::FAIL : Jaribio::Record::PASS, :error => error)
      @results[key] = record
    end

    # 
    # Should this return?
    # - jaribio_key if set (and desc based on that)
    # - otherwise
    # -- example_group full description (md5)
    #
    def get_example_key(example)
      key, desc = find_jaribio_key(example)
      if (key.nil?)
        key = example_group.metadata[:example_group][:full_description]
        desc = key
        key = Base64.strict_encode64(Digest::MD5.digest(key))
      end
      return key, desc
    end

    #
    # metadata of a group is shared with descendants
    # must check ancestors until key not found (if it is found)
    #
    def find_jaribio_key(example)
      key, desc = nil, nil
      if defined? example.metadata and example.metadata.has_key?(:jaribio_key)
        key = example.metadata[:jaribio_key]
        desc = example.full_description
      end
      group = example_group
      while (key.nil? and defined? group) do
        key = group.metadata[:jaribio_key]
        desc = group.metadata[:example_group][:full_description]
        break if group.top_level?
        group = group.superclass
      end

      # after finding the first instance of the key, continue
      # checking up the chain to be sure this where it is defined
      while (defined? key)
        if group.metadata.has_key?(:jaribio_key)
          if (group.metadata[:jaribio_key] != key)
            break
          else
            desc = group.metadata[:example_group][:full_description]
          end
        else
          break
        end
        break if group.top_level?
        group = group.superclass
      end

      return key, desc
    end

    def self.configure()
      RSpec.configure do |c|
        c.add_setting :jaribio_url
        c.add_setting :jaribio_api_key
        c.add_setting :jaribio_plans, :default => []
        c.add_setting :jaribio_auto_create, :default => false
        c.add_setting :jaribio_timeout, :default => 5
      end
    end
  end

  RSpecFormatter.configure
end

