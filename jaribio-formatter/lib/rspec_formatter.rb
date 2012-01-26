#require 'ruby-debug'

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
        output.puts "Desc: #{data[:description]}"
        output.puts "Failed: #{data[:failed].to_s}"
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
    end

    protected
      
    def configuration
      RSpec.configuration
    end

    def record_result(example, failed = false)
      key, desc = get_example_key(example)
      if (@results.has_key?(key))
        failed = failed || @results[key][:failed] 
      end
      @results[key] = {
        :description => desc,
        :failed => failed
      }
    end

    # 
    # Should this return?
    # - jaribio_key if set (and desc based on that)
    # - otherwise
    # -- example full description
    # -- or example_group full description
    #
    def get_example_key(example)
      key, desc = find_jaribio_key(example)
      if (key.nil?)
        key = example_group.metadata[:example_group][:full_description]
        desc = key
      end
      return key, desc
    end

    def find_jaribio_key(example)
      key = nil
      desc = example.full_description
      if example.metadata.has_key?(:jaribio_key)
        key = example.metadata[:jaribio_key]
      end
#      debugger
      group = example_group
      while (key.nil? and not group.top_level?) do
        key = group.metadata[:jaribio_key]
        desc = group.metadata[:example_group][:full_description]
        group = group.superclass
      end
      if (key.nil?)
        key = desc
      end
      return key, desc
    end

  end
end

