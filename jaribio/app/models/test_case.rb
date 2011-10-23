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

  def status(plan_id = nil)
    status = 0

    if plan_id.nil?
      execution = last_execution
    else
      execution = last_execution.where("plan_id = ?", plan_id)
    end
    
    unless execution.nil? or execution.empty?
      status = execution[0].status_code
    end

    return status
  end


  private

  def last_execution
    self.executions.order("created_at desc").limit(1)
  end

end
