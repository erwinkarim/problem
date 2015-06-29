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
			result = StoredLDAP.query(username, password, displayname).first

			if result.nil? then
				return nil
			else
				#user exists in AD. find local user or else, build the user

				user = User.find_by_email(result[:mail].first)
				if user.nil? then
					password = SecureRandom.hex
					user = User.new(:name => result[:displayname].first,
						:username => result[:samaccountname].first,
						:email => result[:mail].first, :password => password, :password_confirmation => password).save!
				end
				return user
			end

		else
			return user
		end
	end

  # like find by displayname, but using the eail
  def self.find_by_mail mail, username, password
    user = User.find_by_email mail
    if user.nil? then
      #check from ldap
			result = StoredLDAP.query(username, password, mail).first

      if result.nil? then
        return nil
      else
        #user exists in AD but not in db, recreate one
        password = SecureRandom.hex
        user = User.new(:name => result[:displayname].first, :username => result[:samaccountname].first,
          :email => result[:mail].first, :password => password, :password_confirmation => password)
        user.save!
        return user
      end
    else
      return user
    end
  end
end
