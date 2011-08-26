class Suite < ActiveRecord::Base
  has_and_belongs_to_many :cases
  has_and_belongs_to_many :issues
  has_and_belongs_to_many :plans
  has_many :executed_suites
end
