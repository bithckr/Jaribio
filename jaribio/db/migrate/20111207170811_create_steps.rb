class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :action
      t.string :results
      t.integer :position
      t.integer :test_case_id

      t.timestamps
    end
  end
end
