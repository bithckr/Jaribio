class CreateCasesSuites < ActiveRecord::Migration
  def self.up
    create_table :cases_suites, :id => false do |t|
      t.references :case, :null => false
      t.references :suite, :null => false
    end
  end

  def self.down
    drop_table :cases_suites
  end
end
