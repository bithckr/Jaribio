class CreateIssuesSuites < ActiveRecord::Migration
  def self.up
    create_table :issues_suites, :id => false do |t|
      t.references :issue, :null => false
      t.references :suite, :null => false
    end
  end

  def self.down
    drop_table :issues_suites
  end
end
