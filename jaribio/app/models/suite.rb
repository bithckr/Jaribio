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
end
