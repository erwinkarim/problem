class AddUseFieldToIssueExtraInfoDetails < ActiveRecord::Migration
  def change
    add_column :issue_extra_info_details, :use_field, :integer
  end
end
