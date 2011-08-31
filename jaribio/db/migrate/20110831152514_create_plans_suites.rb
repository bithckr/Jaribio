class CreatePlansSuites < ActiveRecord::Migration
  def self.up
    create_table :plans_suites, :id => false do |t|
      t.references :plan, :null => false
      t.references :suite, :null => false
    end
  end

  def self.down
    drop_table :plans_suites
  end
end
