class SuiteTestCase < ActiveRecord::Base
  set_table_name "suites_test_cases"

  belongs_to :suite
  belongs_to :test_case

  acts_as_list :scope => :suite
end
