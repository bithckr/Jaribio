class TestCase < ActiveRecord::Base
  has_and_belongs_to_many :suites
  has_many :executions
  belongs_to :user

  validates_presence_of :name, :text, :expectations

  class << self
    # Simplistic search functionality
    def search(q, relation = TestCase.scoped)
      t = TestCase.scoped
      relation.where(t.table[:name].matches("%#{q}%"))
    end
  end

  scope :in_plan, lambda{ |plan|
    joins(:suites => :plans ).
    where("plans.id = ?", plan.id).
    select("DISTINCT `test_cases`.*") # kill duplicates
  }

  def status(plan_id = nil)
    status = Status::UNKNOWN

    if plan_id.nil?
      execution = last_execution
    else
      execution = last_execution(plan_id)
    end
    
    unless execution.nil?
      status = execution.status_code
    end

    return status
  end

  def last_execution(plan_id = nil)
    rel = self.executions.order("created_at desc").limit(1)
    if (plan_id)
      rel.where("plan_id = ?", plan_id)
    end
    return rel.first
  end

end
