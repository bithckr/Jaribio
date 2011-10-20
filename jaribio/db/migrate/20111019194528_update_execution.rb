class UpdateExecution < ActiveRecord::Migration
  def self.up
    change_table :executions do |t|
      t.integer :test_case_id, :null => false
      t.integer :plan_id, :null => false
      t.remove :executable_id
      t.remove :executable_type
    end
  end

  def self.down
    change_table :executions do |t|
      t.remove :test_case_id
      t.remove :plan_id
      t.integer  :executable_id,   :null => false
      t.string   :executable_type, :null => false
    end
  end
end
