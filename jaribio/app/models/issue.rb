class Issue < ActiveRecord::Base
  has_and_belongs_to_many :suites

  validates_presence_of :name, :url
end
