class AddSuitesFk < ActiveRecord::Migration
  def self.up
    add_foreign_key(:suites, :users)
  end

  def self.down
    remove_foreign_key(:suites, :users)
  end
end
