class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.references :user, :null => false
      t.string :name, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
