class ExecutedSuite < ActiveRecord::Base
  belongs_to :suite
  has_one :execution, :as => :execution
end
