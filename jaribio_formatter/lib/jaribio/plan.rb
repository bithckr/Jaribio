require 'jaribio/remote_object'

module Jaribio
  class Plan < RemoteObject
    def open?
      if self.respond_to?(:closed_at)
        return (closed_at == nil or closed_at > Time.now)
      end
      true
    end
  end
end

