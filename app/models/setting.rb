class Setting < ActiveRecord::Base
	validates :key, :uniqueness => { :scope => :category, :message => "once unique value per category" }

	def self.getValue category, key
		if ActiveRecord::Base.connection.table_exists? 'settings' then
			handle = Setting.where(:category => category, :key => key).first
			return handle.nil? ? nil : handle.value
		else
			nil
		end
	end

	def self.setValue category, key,value
		if ActiveRecord::Base.connection.table_exists? 'settings' then
			Setting.where(:category => category, :key => key).first.update_attribute(:value ,value)
		end
	end

	def self.loadIntoMemory
		Setting.all.inject({}) do |result,setting|
			if result[setting.category.to_sym].nil? then
				# result.merge( { setting.category.to_sym => {} } )
				result[setting.category.to_sym] = {} 
			end
			result[setting.category.to_sym]  = result[setting.category.to_sym].merge( { setting.key.to_sym => setting.value } )
			result = result
		end
	end

end
