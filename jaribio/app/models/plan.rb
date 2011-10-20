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

  def status
    case rand(3)
    when 0
      Status::UNKNOWN
    when 1
      Status::PASS
    when 2
      Status::FAIL
    end
  end
end
