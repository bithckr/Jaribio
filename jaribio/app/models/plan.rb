class Plan < ActiveRecord::Base
  has_and_belongs_to_many :suites
  has_many :executions, :as => :executable
  belongs_to :user

  validates_presence_of :name

  class << self
    # Simplistic search functionality
    def search(q)
      t = Plan.scoped
      t.where(t.table[:name].matches("%#{q}%"))
    end
  end

end
