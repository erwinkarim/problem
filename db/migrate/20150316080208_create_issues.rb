class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.text :description
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :issues, :users
  end
end
