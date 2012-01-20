class TestCase < ActiveRecord::Base
  has_many :suite_test_cases
  has_many :suites, :through => :suite_test_cases
  has_many :executions
  has_many :steps, :order => "steps.sort_order ASC"
  belongs_to :user
  belongs_to :pre_step

  validates_presence_of :name, :unique_key
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

    execution = last_execution(plan_id)
    unless execution.nil?
      status = execution.status_code
    end

    return status
  end

  def last_execution(plan_id = nil)
    rel = self.executions.scoped
    unless (plan_id.nil?)
      rel = rel.where("plan_id = ?", plan_id)
    end
    rel = rel.order("created_at desc").limit(1)
    return rel.first
  end

  # deep_clone assumes you are cloning for the purpose of creating
  # a duplicate database record, therefore it intentionally skips
  # some data such as executions.
  def deep_clone
    # use deep_cloneable to create a clone of most of the test_case
    new_case = self.dup(:include => [:steps], :except => [:unique_key, {:steps => :id}])
    # couldn't get the suites to copy, but those are simple enough
    new_case.suite_ids=self.suite_ids
    return new_case
  end
end
