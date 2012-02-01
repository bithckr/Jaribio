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
    # -- example_group full description
    #
    def get_example_key(example)
      key, desc = find_jaribio_key(example)
      if (key.nil?)
        key = example_group.metadata[:example_group][:full_description]
        desc = key
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

  end
end

