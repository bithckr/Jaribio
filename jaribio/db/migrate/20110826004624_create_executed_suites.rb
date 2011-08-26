class CreateExecutedSuites < ActiveRecord::Migration
  def self.up
    create_table :executed_suites do |t|
      t.references :suite, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :executed_suites
  end
end
