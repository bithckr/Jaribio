class Step < ActiveRecord::Base
  belongs_to :test_case

  acts_as_list :scope => :test_case
end
