class DropAnwersFromQuestion < ActiveRecord::Migration
  def up
		remove_column :questions, :answer_id
  end

	def down
		add_column :questions, :answer_id, :integer
	end
end
