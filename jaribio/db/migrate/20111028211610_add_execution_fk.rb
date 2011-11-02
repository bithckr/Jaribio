class AddExecutionFk < ActiveRecord::Migration
  def self.up
    add_foreign_key(:executions, :test_cases, :dependent => :delete)
    add_foreign_key(:executions, :plans, :dependent => :delete)
    add_foreign_key(:executions, :users)
  end

  def self.down
    remove_foreign_key(:executions, :test_cases)
    remove_foreign_key(:executions, :plans)
    remove_foreign_key(:executions, :users)
  end
end
