class CreateIssueExtraInfoDetails < ActiveRecord::Migration
  def change
    create_table :issue_extra_info_details do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
