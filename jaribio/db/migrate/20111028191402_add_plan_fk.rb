class AddPlanFk < ActiveRecord::Migration
  def self.up
    add_foreign_key(:plans, :users)
  end

  def self.down
    remove_foreign_key(:plans, :users)
  end
end
