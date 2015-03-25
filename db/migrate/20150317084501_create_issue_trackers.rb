class CreateIssueTrackers < ActiveRecord::Migration
  def change
    create_table :issue_trackers do |t|
      t.references :issue, index: true
      t.references :old_status, index: true
      t.references :new_status, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :issue_trackers, :issues
    #add_foreign_key :issue_trackers, :old_statuses
    add_foreign_key :issue_trackers, :issue_statuses, column: :old_statuses, primary_key: 'id'
    #add_foreign_key :issue_trackers, :new_statuses
    add_foreign_key :issue_trackers, :issue_statuses, column: :new_statues, primary_key: 'id'
    add_foreign_key :issue_trackers, :users
  end
end
