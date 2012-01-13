class DropTestCaseFields < ActiveRecord::Migration
  def up
    remove_column :test_cases, :text
    remove_column :test_cases, :expectations
  end

  def down
    add_column :test_cases, :text, :text
    add_column :test_cases, :expectations, :text
  end
end
