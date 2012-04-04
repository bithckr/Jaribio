class ConvertToActsAsList < ActiveRecord::Migration

  class Suite < ActiveRecord::Base
    has_many :suite_test_cases
  end

  class TestCase < ActiveRecord::Base
    has_many :steps
  end

  def up
    add_column :steps, :position, :integer, :default => 0
    add_column :suites_test_cases, :position, :integer, :default => 0
    add_index :steps, :position
    add_index :steps, [:test_case_id, :position]
    add_index :suites_test_cases, :position

    Suite.find_each do |suite|
      pos = 1
      suite.suite_test_cases.order('sort_order ASC').each do |stc|
        stc.update_column(:position, pos)
        pos += 1
      end
    end

    TestCase.find_each do |test|
      pos = 1
      test.steps.order('sort_order ASC').each do |step|
        step.update_column(:position, pos)
        pos += 1
      end
    end
  end

  def down
    remove_index :steps, :position
    remove_index :steps, [:test_case_id, :position]
    remove_index :suites_test_cases, :position
    remove_column :steps, :position
    remove_column :suites_test_cases, :position
  end
end
