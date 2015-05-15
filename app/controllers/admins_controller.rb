class AdminsController < ApplicationController
	before_action :admins_only
		
	def index
		@admins = Admin.all
	end

	def create
		@user = params[:username]

		@user = Admin.new(:samaccountname => params[:username] )
		respond_to do |format|
			if @user.save! then
				format.template
			else
				format.template { render :nothing => true, :status => :precondition_failed }
			end
		end
	end

	def destroy
	
		if Admin.find_by_id(params[:id]).destroy! then	
			respond_to do |format|
				format.html { render :nothing => true, :status => :ok }
			end
		else
			respond_to do |format|
				format.html { render :nothing => true, :status => :internal_server_error }
			end
		end
	end

	# GET    /admins/search
	# returns a list of SAM-account-names when passed a params[:query]
	def search
		
	end

	# GET /admins/report
	# show report on  admin's performance
	def report
	end

	# GET    /admins/setup
	# show setup page
	def setup
		@categories = Setting.all.pluck(:category).uniq
	end

	def update_setup
		params[:settings].each do |category|
			Rails.logger.info "category => #{category[0]}"
			category[1].each do |key, value|
				Rails.logger.info "key => #{key}, value => #{value}"
				Setting.setValue category, key, value
			end 
		end
		

		Problem::Settings.loadIntoMemory

		redirect_to setup_admins_path
	end

	def check_setup
		Rails.logger.info "check setup"
	end
end
