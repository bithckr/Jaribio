class AddSuitesTestCasesFk < ActiveRecord::Migration
  def self.up
    change_table :suites_test_cases do |t|
      t.foreign_key :test_cases, :dependent => :delete
      t.foreign_key :suites, :dependent => :delete
    end
  end

  def self.down
    change_table :suites_test_cases do |t|
      t.remove_foreign_key :test_cases
      t.remove_foreign_key :suites
    end
  end
end
