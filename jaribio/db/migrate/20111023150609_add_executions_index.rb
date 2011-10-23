class AddExecutionsIndex < ActiveRecord::Migration
  def self.up
    add_index :executions, [:plan_id, :test_case_id]
  end

  def self.down
    remove_index :executions, [:plan_id, :test_case_id]
  end
end
