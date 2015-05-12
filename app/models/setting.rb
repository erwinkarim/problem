class Setting < ActiveRecord::Base
	validates :key, :uniqueness => { :scope => :category, :message => "once unique value per category" }
end
