class ChangeIndexOnSuiteNameToUnique < ActiveRecord::Migration
  def up
    remove_index :suites, :name
    add_index :suites, :name, :unique => true
  end

  def down
    remove_index :suites, :name
    add_index :suites, :name
  end
end
