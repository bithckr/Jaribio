class AddIndexesForSearch < ActiveRecord::Migration
  def self.up
    add_index :test_cases, :name
    add_index :issues, :name
    add_index :issues, :url
    add_index :plans, :name
    add_index :suites, :name
  end

  def self.down
    remove_index :test_cases, :name
    remove_index :issues, :name
    remove_index :issues, :url
    remove_index :plans, :name
    remove_index :suites, :name
  end
end
