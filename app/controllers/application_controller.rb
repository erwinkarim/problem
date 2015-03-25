class ApplicationController < ActionController::Base
	before_action :authenticate_user!	
	def not_found
		raise ActionController::RoutingError.new('Not Found')
		#raise ActiveRecord::RecordNotFound
	end

	rescue_from ActionController::RoutingError, :with => :record_not_found

	def record_not_found
		render :file => 'public/404.html', :status => :not_found
	end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

end
