class CreateExecutions < ActiveRecord::Migration
  def self.up
    create_table :executions do |t|
      t.references :plan
      t.references :issue
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :executions
  end
end
