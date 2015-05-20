class UsersController < ApplicationController
	def index
	end

	#  GET    /users/:id(.:format)
	def show
		user = User.find_by_username(params[:id]) or not_found

		respond_to do |format|
			format.html
		end
	end

	def settings
	end

	# GET /users/search
	# required params query
	def search
		query = params[:query] 

		if !query.nil? then
			results = StoredLDAP.query("#{current_user.username}@PETRONAS.PETRONET.DIR", session[:password], query)
			Rails.logger.info "results: #{results}"
		end
		
		respond_to do |format|
			format.json {
				init_hash = { :options => [], :emails => [] }
				if !results.nil? then
					results[0..10].each do |x| 
						init_hash[:options] << x[:displayname][0]
						init_hash[:emails] << x[:mail][0]
					end
				end
				render :json => init_hash
			}
		end
	end

end

