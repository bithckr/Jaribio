class AddClosedatToPlans < ActiveRecord::Migration
  def up
    add_column :plans, :closed_at, :datetime, :default => nil
  end
  def down
    remove_column :plans, :closed_at
  end
end
