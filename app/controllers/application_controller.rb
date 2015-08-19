class ApplicationController < ActionController::Base
	force_ssl
	before_action :authenticate_user!
	#before_action :check_setup

	#go to the page after sign in
	def after_sign_in_path_for(resource)
		request.env['omniauth.origin'] || stored_location_for(resource) || root_path
	end

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

	private

	def admins_only
		redirect_to issues_path(current_user) unless current_user.admin?
	end

	def check_setup
		if Problem::Settings.getValue(:devise, :ldap_host).nil? then
			#prevent loop back
				redirect_to setup_admins_path
		else
			#:authenticate_users!
			Rails.logger.info "redirect to new_user_session_path"
			redirect_to new_user_session_path
		end
		Rails.logger.info "do nothing"
		Rails.logger.info request.env['HTTP_REFERER']
	end
end
