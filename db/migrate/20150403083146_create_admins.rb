class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :samaccountname

      t.timestamps null: false
    end
  end
end
