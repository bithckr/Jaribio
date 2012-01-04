class AddTestCasePreStepFk < ActiveRecord::Migration
  def up
    add_column :test_cases, :pre_step_id, :integer
    add_foreign_key :test_cases, :pre_steps
  end

  def down
    remove_foreign_key :test_cases, :pre_steps
    remove_column :test_cases, :pre_step_id
  end
end
