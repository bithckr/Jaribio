class AddIdToSuitesTestCases < ActiveRecord::Migration
  def change
    add_column :suites_test_cases, :id, :primary_key
  end
end
