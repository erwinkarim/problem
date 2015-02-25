require 'net/ldap'
require 'devise/strategies/authenticatable'

module Devise
	module Strategies
		class LdapAuthenticatable < Authenticatable
			def authenticate!
				if params[:user]
					ldap = Net::LDAP.new
					ldap.host = ENV['devise_ldap_host']
					ldap.port = 636
					ldap.base = ENV['devise_ldap_base']
					ldap.encryption :simple_tls
					#ldap.auth "#{login}@#{params[:user][:domain]}", password
					ldap.auth "#{params[:user][:username]}@#{params[:user][:domain]}", password

					valid_login = false
					in_group = false
						
					if ldap.bind
						valid_login = true
		
						#find the user
						filter = Net::LDAP::Filter.eq( 'samaccountname', params[:user][:username] )
						search_result = ldap.search( :base => ENV['devise_ldap_base'], :filter => filter).first

						#check if the user is in the proper group
						if ENV['devise_check_group'] == 'true' then
							group_search_results = ldap.search( :base => search_result[:dn].first, 
								:filter => Net::LDAP::Filter.ex( "memberof:1.2.840.113556.1.4.1941", ENV['devise_req_groups']),
								:scope => Net::LDAP::SearchScope_BaseObject)
							if group_search_results.length == 1 then
								in_group = true
							end
						else
							in_group = true
						end	
					end

					if valid_login && in_group then
						#start looking for user or create a new one
						user = User.where(:username => params[:user][:username]).first

						if user.nil? then
							user = User.new(:username => params[:user][:username], 
								:email => search_result[:mail].first, 
								:name => search_result[:displayname].first, 
								#:username => search_result[:samaccountname].first, 
								:password => params[:user][:password], :domain => params[:user][:domain] )
							user.save!
							params[:user][:email] = search_result[:mail].first
						else
							user.update_attributes({ :email => search_result[:mail].first, 
								:name => search_result[:displayname].first, 
								:password => params[:user][:password], :domain => params[:user][:domain] } )
						end

						success!(user)
					else
						#somehow this doesn't work if the user have logon before so blank out username field
						params[:user][:username] = ""
						return fail(:invalid)
					end
				end
			end

			#def email
			#	params[:user][:username] + "@petronas.com.my"
			#end

			def login
				params[:user][:username]
			end

			def password
				params[:user][:password]
			end

			def login
				params[:user][:username]
			end

			def user_data 
				login:login
			end
		end
	end
end

Warden::Strategies.add(:ldap_authenticatable, Devise::Strategies::LdapAuthenticatable)
