require 'jaribio/plan'
require 'jaribio/test_case'
require 'cgi'

module Jaribio
  class Execution < RemoteObject
    self.prefix = '/plans/:plan_id/cases/:test_case_id/'
  end
end
