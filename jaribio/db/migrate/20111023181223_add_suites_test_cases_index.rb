class AddSuitesTestCasesIndex < ActiveRecord::Migration
  def self.up
    add_index :suites_test_cases, [:suite_id, :test_case_id]
  end

  def self.down
    remove_index :suites_test_cases, [:suite_id, :test_case_id]
  end
end
