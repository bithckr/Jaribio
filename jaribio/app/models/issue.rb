class Issue < ActiveRecord::Base
  has_many :executions
end
