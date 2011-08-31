class TestCase < ActiveRecord::Base
  has_and_belongs_to_many :suites
  has_many :executions, :as => :executable

  belongs_to :user
end
