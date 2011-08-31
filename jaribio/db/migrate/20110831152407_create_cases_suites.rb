class CreateCasesSuites < ActiveRecord::Migration
  def self.up
    create_table :suites_test_cases, :id => false do |t|
      t.references :test_case, :null => false
      t.references :suite, :null => false
    end
  end

  def self.down
    drop_table :suites_test_cases
  end
end
