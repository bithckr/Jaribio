class AddUniqueIdToTestCases < ActiveRecord::Migration
  def self.up
    change_table :test_cases do |t|
      t.string :unique_key, :null => false
    end

    TestCase.all.each do |tc|
        tc.update_attributes!(:unique_key => Time.now.hash.abs.to_s(36).upcase);
    end

    add_index :test_cases, :unique_key, :unique => true
  end

  def self.down
    change_table :test_cases do |t|
      t.remove :unique_key
    end
  end
end
