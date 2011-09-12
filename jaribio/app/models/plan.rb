class Plan < ActiveRecord::Base
  has_and_belongs_to_many :suites
  has_many :executions, :as => :executable
  belongs_to :user

  validates_presence_of :name
end
