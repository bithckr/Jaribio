class TestCase < ActiveRecord::Base
  has_and_belongs_to_many :suites
  has_many :executions, :as => :executable
  belongs_to :user

  validates_presence_of :name, :text, :expectations

  class << self
    # Simplistic search functionality
    def search(q, relation = TestCase.scoped)
      t = TestCase.scoped
      relation.where(t.table[:name].matches("%#{q}%"))
    end
  end
end
