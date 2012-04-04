class RemoveRankedModel < ActiveRecord::Migration
  def up
    remove_index :steps, :sort_order
    remove_index :steps, [:test_case_id, :sort_order]
    remove_column :steps, :sort_order

    remove_index :suites_test_cases, :sort_order
    remove_column :suites_test_cases, :sort_order
  end

  # if you really have to go down, you will have to 
  # do something to set the sort_order_position
  def down
    add_column :steps, :sort_order, :null => false
    add_index :steps, :sort_order
    add_index :steps, [:test_case_id, :sort_order]

    add_column :suites_test_cases, :sort_order, :null => false
    add_index :suites_test_cases, :sort_order
  end
end
