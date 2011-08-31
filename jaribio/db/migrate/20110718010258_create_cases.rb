class CreateCases < ActiveRecord::Migration
  def self.up
    create_table :test_cases do |t|
      t.references :user, :null => false
      t.text :text, :null => false
      t.text :expectations, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :test_cases
  end
end
