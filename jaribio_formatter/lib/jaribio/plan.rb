require 'active_resource'

module Jaribio
  class Plan < ActiveResource::Base
    # site is set as needed by formatters
    
    # use json, not xml
    self.format = :json

    # set timeout to 5 seconds (does not affect DNS lookups generally)
    self.timeout = 5

    # Usage: Jaribio::Plan.find(1, :params => {'api_key' => 'asdf'})
  end
end

