class AddAssigneeToIssues < ActiveRecord::Migration
  def change
    add_reference :issues, :assignee, index: true
    add_foreign_key :issues, :assignees
  end
end
