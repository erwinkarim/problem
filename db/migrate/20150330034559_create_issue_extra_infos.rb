class CreateIssueExtraInfos < ActiveRecord::Migration
  def change
    create_table :issue_extra_infos do |t|
      t.references :extra_info_detail, index: true
      t.references :issue, index: true
      t.string :string_val
      t.integer :int_val

      t.timestamps null: false
    end
    add_foreign_key :issue_extra_infos, :extra_info_details
    add_foreign_key :issue_extra_infos, :issues
  end
end
