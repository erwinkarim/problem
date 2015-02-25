class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :statement
      t.references :parent, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
