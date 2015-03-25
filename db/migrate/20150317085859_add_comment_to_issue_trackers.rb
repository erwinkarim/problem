class AddCommentToIssueTrackers < ActiveRecord::Migration
  def change
    add_column :issue_trackers, :comment, :string
  end
end
