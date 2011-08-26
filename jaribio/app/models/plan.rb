class Plan < ActiveRecord::Base
  has_and_belongs_to_many :suites
  has_many :executed_plans
end
