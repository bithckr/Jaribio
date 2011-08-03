class Plan < ActiveRecord::Base
  has_many :executions
end
