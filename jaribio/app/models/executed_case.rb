class ExecutedCase < ActiveRecord::Base
  belongs_to :case
  has_one :execution, :as => :execution
end
