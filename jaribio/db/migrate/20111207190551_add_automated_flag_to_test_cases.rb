class AddAutomatedFlagToTestCases < ActiveRecord::Migration
  def change
    add_column :test_cases, :automated, :boolean, :default => false, :null => false
  end
end
