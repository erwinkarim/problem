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
end
