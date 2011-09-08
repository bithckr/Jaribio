class TestCase < ActiveRecord::Base
  has_and_belongs_to_many :suites
  has_many :executions, :as => :executable

  belongs_to :user

  scope :search

  class << self
    # Simplistic search functionality
    def search(q)
      t = TestCase.scoped
      t.where(t.table[:name].matches("%#{q}%").
              or(t.table[:text].matches("%#{q}%")).
              or(t.table[:expectations].matches("%#{q}%")))
    end
  end
end
