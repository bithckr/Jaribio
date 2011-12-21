class AddOrderToSuitesTestCases < ActiveRecord::Migration
  def change
    add_column :suites_test_cases, :sort_order, :integer
    add_index :suites_test_cases, :sort_order
  end

end
