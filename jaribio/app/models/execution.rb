class Execution < ActiveRecord::Base
  belongs_to :user
  belongs_to :test_case
  belongs_to :plan

  validates_presence_of :status_code
end
