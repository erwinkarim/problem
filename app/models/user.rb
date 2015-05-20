class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
					# :registerable, #:recoverable, 
				 :rememberable, :trackable, :validatable
	validates :username, presence: true, uniqueness: true
	has_many :issues	
	#has_many :assigned_issues, :foreign_key => 'assignee'
	#
	def admin?
		result = Admin.find_by_samaccountname(self.username)	
		if !result.nil? || self.username == ENV['default_admin']
			return true
		else
			return false
		end
	end

	def self.find_by_displayname displayname, username, password
		user = User.find_by_name displayname
		if user.nil? then
			#check from ldap
			ldap = StoredLDAP.query(username, password, displayname)
			
			
		else
			return user
		end
	end
end
