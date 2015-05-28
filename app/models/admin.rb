class Admin < ActiveRecord::Base
	belongs_to :user
	validates :samaccountname, :presence => true, :uniqueness => true 

	def self.search
		#bind to ldap
		# search using ldap filters
		# return list of possible SAM-account-names
	end

end
