require 'active_resource'
require 'active_support/core_ext/class/attribute_accessors'

module Jaribio
  class RemoteObject < ActiveResource::Base
    cattr_accessor :api_key

    # use json, not xml
    self.format = :json

    # set timeout to 5 seconds (does not affect DNS lookups generally)
    self.timeout = 5

    class << self
      def query_string(options)
        options = {} if options.nil?
        options[:api_key] = api_key unless api_key.nil?
        super(options)
      end
    end

  end
end
