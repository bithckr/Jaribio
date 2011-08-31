class AddNameToTestCase < ActiveRecord::Migration
  def self.up
    change_table :test_cases do |t|
      t.string :name, :null => false
    end
  end

  def self.down
    change_table :test_cases do |t|
      t.remove :name
    end
  end
end
