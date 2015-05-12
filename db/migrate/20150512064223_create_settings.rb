class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :category
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end
