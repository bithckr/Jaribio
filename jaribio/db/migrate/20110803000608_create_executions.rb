class CreateExecutions < ActiveRecord::Migration
  def self.up
    create_table :executions do |t|
      t.timestamps
      t.integer    :executable_id, :null => false
      t.string     :executable_type, :null => false
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
