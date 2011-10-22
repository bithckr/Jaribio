class Plan < ActiveRecord::Base
  has_and_belongs_to_many :suites
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
    execution = Execution.find_by_sql(["select LEFT(GROUP_CONCAT(status_code order by " +
                                      "created_at desc), 1) as status_code from executions " +
                                      "where plan_id = ? group by test_case_id order by " +
                                      "status_code desc limit 1", self.id])
    unless execution.nil? or execution.empty?
      status = execution[0].status_code
    end
    
    return status
  end
end
