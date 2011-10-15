class Suite < ActiveRecord::Base
  has_and_belongs_to_many :test_cases
  has_and_belongs_to_many :issues
  has_and_belongs_to_many :plans
  has_many :executions, :as => :executable
  belongs_to :user

  validates_presence_of :name

  class << self
    # Simplistic search functionality
    def search(q)
      t = Suite.scoped
      t.where(t.table[:name].matches("%#{q}%"))
    end
  end

  def search_test_cases(q)
    t = TestCase.scoped
    test_cases.scoped.where(t.table[:name].matches("%#{q}%"))
  end

  def available_test_cases
    test_cases = Arel::Table.new(:test_cases)
    suites_test_cases = Arel::Table.new(:suites_test_cases)
    related_test_cases = test_cases.project(test_cases[:id]).join(suites_test_cases).on(test_cases[:id].eq(suites_test_cases[:test_case_id])).where(suites_test_cases[:suite_id].eq(self.id))
    TestCase.scoped.where(test_cases[:id].not_in(related_test_cases))
  end

  def search_available_test_cases(q)
    t = TestCase.scoped
    available_test_cases.where(t.table[:name].matches("%#{q}%"))
  end

end
