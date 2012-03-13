require 'active_resource'
require 'active_support/core_ext/class/attribute_accessors'

module Jaribio
  class RemoteObject < ActiveResource::Base
    cattr_accessor :api_key

    # use json, not xml
    self.format = :json

    class << self
      # Override query_string to automatically add the api_key
      def query_string(options)
        options = {} if options.nil?
        options[:api_key] = api_key unless api_key.nil?
        super(options)
      end

      def configure(config)
        self.site = config.jaribio_url
        self.api_key = config.jaribio_api_key
        # set timeout (does not affect DNS lookups generally)
        self.timeout = config.jaribio_timeout
      end
    end

  end
end
