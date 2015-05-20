class AddAffectedUserToIssue < ActiveRecord::Migration
  def change
    add_reference :issues, :affected_user, index: true
    add_foreign_key :issues, :affected_users
  end
end
