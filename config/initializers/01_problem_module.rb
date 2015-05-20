require "#{Rails.root}/lib/stored_ldap.rb"

module Problem
  REVISION = `git describe --always`
	
	module Settings
		@@theHash = nil 

		def self.getValue category, key
			if @@theHash.nil? then
				return nil
			else
				if @@theHash[category.to_sym].nil? then
					return nil
				else
					return @@theHash[category.to_sym][key.to_sym]
				end
			end
		end

		def self.loadIntoMemory
			if ActiveRecord::Base.connection.table_exists? 'settings' then
				@@theHash = Setting.loadIntoMemory
			else
				@@theHash = nil
			end
		end

	end

	Settings.loadIntoMemory
end
