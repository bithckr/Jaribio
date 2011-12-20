class TestCase < ActiveRecord::Base
  has_many :suite_test_cases
  has_many :suites, :through => :suite_test_cases
  has_many :executions
  belongs_to :user

  validates_presence_of :name, :unique_key, :text, :expectations
  validates_uniqueness_of :unique_key
  
  class << self
    # Simplistic search functionality
    def search(query, relation = TestCase.scoped)
      #'field:value' for example: 'name:my test case'
      if (query.to_s =~ /:/)
        q = query.to_s.split(/:/, 2);
      else
        q = ['name', query];
      end

      t = TestCase.scoped
      relation.where(t.table[q[0].to_sym].matches("%#{q[1]}%"))
    end
  end

  scope :in_plan, lambda{ |plan|
    joins(:suites => :plans ).
    where("plans.id = ?", plan.id).
    select("DISTINCT `test_cases`.*") # kill duplicates
  }

  def unique_key
    ukey = read_attribute(:unique_key);
    if (ukey.to_s.empty?)
        ukey = Time.now.hash.abs.to_s(36).upcase
        write_attribute(:unique_key, ukey)
    end

    return ukey;
  end
  
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
