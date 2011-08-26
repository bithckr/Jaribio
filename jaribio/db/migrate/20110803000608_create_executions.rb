class CreateExecutions < ActiveRecord::Migration
  def self.up
    create_table :executions do |t|
      t.timestamps
      t.integer    :execution_id, :null => false
      t.string     :execution_type, :null => false
      t.references :user, :null => false
      t.integer    :status_code, :null => false
      t.string     :environment
      t.text       :results
    end
  end

  def self.down
    drop_table :executions
  end
end
