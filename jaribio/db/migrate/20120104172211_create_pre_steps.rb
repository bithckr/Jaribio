class CreatePreSteps < ActiveRecord::Migration
  def change
    create_table :pre_steps do |t|
      t.string :name
      t.text :list

      t.timestamps
    end
    add_index :pre_steps, :name, :unique => true
  end
end
