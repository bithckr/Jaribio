class AddStepFk < ActiveRecord::Migration
  def up
    add_foreign_key(:steps, :test_cases, :dependent => :delete)
  end

  def down
    remove_foreign_key(:steps, :test_cases)
  end
end
