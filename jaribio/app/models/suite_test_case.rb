class SuiteTestCase < ActiveRecord::Base
  set_table_name "suites_test_cases"

  belongs_to :suite
  belongs_to :test_case

  include RankedModel
  ranks :sort_order, :with_same => :suite_id

end
