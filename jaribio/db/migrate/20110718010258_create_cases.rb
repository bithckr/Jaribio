class CreateCases < ActiveRecord::Migration
  def self.up
    create_table :cases do |t|
      t.references :user
      t.text :text
      t.text :expectations

      t.timestamps
    end
  end

  def self.down
    drop_table :cases
  end
end
