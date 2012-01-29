class Plan < ActiveRecord::Base
  has_and_belongs_to_many :suites, :order => "suites.name ASC"
  has_many :executions
  belongs_to :user

  validates_presence_of :name

  class << self
    # Simplistic search functionality
    def search(q, relation = Plan.scoped)
      t = Plan.scoped
      relation.where(t.table[:name].matches("%#{q}%"))
    end
  end

  def available_suites
    suites = Arel::Table.new(:suites)
    plans_suites = Arel::Table.new(:plans_suites)
    related_suites = suites.project(suites[:id]).join(plans_suites).on(suites[:id].eq(plans_suites[:suite_id])).where(plans_suites[:plan_id].eq(self.id))
    Suite.scoped.where(suites[:id].not_in(related_suites))
  end

  # NOTE: The status method is not portable and will work on MySQL only. This was
  # done for performance reasons.
  def status
    status = Status::UNKNOWN
    # Here we select the last execution per test_case per plan, then we order the
    # result set by status code because we can determine if a plan is failing by
    # inspecting only one record. If we have not recorded any executions for the
    # given plan, then we return Status::UNKNOWN.
    results = Execution.find_by_sql(["select LEFT(GROUP_CONCAT(status_code order by " +
                                     "created_at desc), 1) as status_code, test_case_id from executions " +
                                     "where plan_id = ? group by test_case_id order by " +
                                     "status_code desc", self.id])

    cases = Array.new
    self.suites.each do |suite|
      if (self.closed_at.nil?)
        cases += suite.test_cases
      else
        cases += suite.test_cases.where("created_at < ?", self.closed_at)
      end
    end
    # remove test cases used in multiple suites
    case_count = cases.uniq.size

    # count our passes and failures, but limit it to only the current list of test cases within
    # our plan. This ensures we handle the case where test cases are removed from a suite after
    # we execute the test case for the plan.
    passes = results.count{|r| r.status_code == Status::PASS && cases.index{|i| i.id == r.test_case_id} }
    fails  = results.count{|r| r.status_code == Status::FAIL && cases.index{|i| i.id == r.test_case_id} }
    unknowns = case_count - (passes + fails)

    if(fails > 0)
      status = Status::FAIL
    elsif((case_count > 0) && (passes == case_count))
      status = Status::PASS
    end

    return [ status, passes, fails, unknowns ]
  end

  def test_cases
    TestCase.in_plan(self)
  end
end
