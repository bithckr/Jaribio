module Jaribio
  class Record
    PASS = 1
    FAIL = 0

    attr_accessor :key, :description, :state

    def initialize(args)
      key = args[:key] 
      description = args[:description]
      state = args[:state]
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
