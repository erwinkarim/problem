class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :user, index: true
      t.string :statement

      t.timestamps null: false
    end
    add_foreign_key :answers, :users
  end
end
