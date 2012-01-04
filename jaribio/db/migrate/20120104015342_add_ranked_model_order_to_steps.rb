class AddRankedModelOrderToSteps < ActiveRecord::Migration

  class Step < ActiveRecord::Base
    belongs_to :test_case

    include RankedModel
    ranks :sort_order, :with_same => :test_case_id
  end

  class TestCase < ActiveRecord::Base
    has_many :steps
  end

  def up
    change_table :steps do |t|
      t.integer :sort_order, :null => false
    end

    Step.reset_column_information
    TestCase.find_each do |tc|
      tc.steps.order("position").each do |step|
        step.sort_order_position = :last
        step.save!
      end
    end

    add_index :steps, :sort_order
    add_index :steps, [:sort_order, :test_case_id], :unique => true
    remove_column :steps, :position
  end

  def down
    add_column :steps, :position, :integer

    Step.reset_column_information
    TestCase.find_each do |tc|
      tc.steps.order("sort_order ASC").each_with_index do |step, i|
        step.position = i
        step.save!
      end
    end

    remove_index :steps, :sort_order
    remove_index :steps, [:sort_order, :test_case_id]
    remove_column :steps, :sort_order
  end
end
