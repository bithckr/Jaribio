class AddPlansSuitesFk < ActiveRecord::Migration
  def self.up
    change_table :plans_suites do |t|
      t.foreign_key :plans, :dependent => :delete
      t.foreign_key :suites, :dependent => :delete
    end
  end

  def self.down
    change_table :plans_suites do |t|
      t.remove_foreign_key :plans
      t.remove_foreign_key :suites
    end
  end
end
