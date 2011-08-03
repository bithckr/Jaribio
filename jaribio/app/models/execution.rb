class Execution < ActiveRecord::Base
  belongs_to :plan
  belongs_to :issue
  belongs_to :user
end
