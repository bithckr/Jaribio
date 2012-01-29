class Suite < ActiveRecord::Base
  has_many :suite_test_cases
  has_many :test_cases, :through => :suite_test_cases, :order => "suites_test_cases.sort_order ASC"
  has_and_belongs_to_many :issues
  has_and_belongs_to_many :plans
  belongs_to :user

  validates_presence_of :name

  class << self
    # Simplistic search functionality
    def search(q, relation = Suite.scoped)
      t = Suite.scoped
      relation.where(t.table[:name].matches("%#{q}%"))
    end
  end

  def available_test_cases
    test_cases = Arel::Table.new(:test_cases)
    suites_test_cases = Arel::Table.new(:suites_test_cases)
    related_test_cases = test_cases.project(test_cases[:id]).join(suites_test_cases).on(test_cases[:id].eq(suites_test_cases[:test_case_id])).where(suites_test_cases[:suite_id].eq(self.id))
    TestCase.scoped.where(test_cases[:id].not_in(related_test_cases))
  end

  # NOTE: The status method is not portable and will work on MySQL only. This was
  # done for performance reasons.
  def status(plan_id = nil) 
    status = Status::UNKNOWN
    plan_context = ''
    plan = Plan.new

    # If a plan_id is provided, then we restrict the suite status to this plan
    # else the suite status will rely on the last executions for its test cases.
    unless plan_id.nil?
        plan_context = "and plan_id = #{plan_id}"
        plan = Plan.find(plan_id)
    end

    # Here we select the last execution per test_case in the suite, then we order the
    # result set by status code because we can determine if a suite is failing by
    # inspecting only one record. If we have not recorded any executions for the
    # given suite, then we return Status::UNKNOWN.
    execution = Execution.find_by_sql(["select LEFT(GROUP_CONCAT(status_code order by " +
                                       "executions.created_at desc), 1) as status_code from executions " +
                                       "inner join suites_test_cases on " +
                                       "executions.test_case_id=suites_test_cases.test_case_id " +
                                       "where suites_test_cases.suite_id=? #{plan_context} " +
                                       "group by executions.test_case_id " +
                                       "order by status_code desc", self.id])

    unless execution.nil? or execution.empty?
      if execution[0].status_code == Status::FAIL
        status = Status::FAIL
      elsif execution[0].status_code == Status::PASS
        if (plan.closed_at.nil?)
         test_count = self.test_cases.size 
        else
         # Only count the test cases that were created before the plan was closed.
         test_count = self.test_cases.where("created_at < ?", plan.closed_at).size
        end

        # A suite can not have a PASS status unless ALL test cases are passing
        status = Status::PASS if(execution.size == test_count)
      end
    end

    return status
  end
end
