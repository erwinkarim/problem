class AddDefaultValueToSetting < ActiveRecord::Migration
  def change
    add_column :settings, :defaultValue, :string
  end
end
