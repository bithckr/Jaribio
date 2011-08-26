class CreateExecutedCases < ActiveRecord::Migration
  def self.up
    create_table :executed_cases do |t|
      t.references :case, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :executed_cases
  end
end
