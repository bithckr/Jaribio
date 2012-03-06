module Jaribio
  class Record
    PASS = 1
    FAIL = 0

    attr_accessor :key, :description, :state

    def initialize(args = {})
      self.key = args[:key] 
      self.description = args[:description]
      self.state = args[:state]
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
  end
end
