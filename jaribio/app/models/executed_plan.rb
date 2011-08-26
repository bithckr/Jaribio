class ExecutedPlan < ActiveRecord::Base
  belongs_to :plan
  has_one :execution, :as => :execution
end
