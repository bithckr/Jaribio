class CreateExecutedPlans < ActiveRecord::Migration
  def self.up
    create_table :executed_plans do |t|
      t.references :plan, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :executed_plans
  end
end
