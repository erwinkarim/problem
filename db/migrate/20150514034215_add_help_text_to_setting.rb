class AddHelpTextToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :HelpText, :string
  end
end
