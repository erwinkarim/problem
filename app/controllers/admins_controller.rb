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
	def reports
		@admins = Admin.all
	end

	#  GET    /admins/reports/:id
	def reports_show
		@admin =  Admin.find_by_id(params[:id])

		respond_to do |format|
			format.html
			format.json {
				#return data for the charts
				#format
				# { :chart1 => 
				# 	{ :categories => [x1,x2,... xn], :series => [ { name: name1, data:[d1_1, d1_2, xxx, d1_n] }, { .. } ] } ,
				# 	:chart2 => 
				# 	{ :categories => ... }
				# }
				if @admin.nil? then
					render :nothing => true
				end
				user = User.find_by_username @admin.samaccountname

				# gather issue performance data
				categories = ((Date.today-180)..Date.today).map{ |d| ["#{d.year}-#{d.month}"] }.uniq.map{ |x| x.first }
				opened_issues = user.issues.group_by_month.map{ |key,value| [Date.parse(key).strftime('%Y-%-m'), value] }
				opened_issues = categories.map do |x| 
					selected = opened_issues.select{ |y| y.first == x }.first	
					selected.nil? ? [x, 0] :  [x, selected[1] ]
				end
				assigned_issues = IssueTracker.where(
					:user_id => user.id , :new_status_id => IssueStatus.find_by_name('Assigned').id).group_by_month.map{ 
						|key,value| [Date.parse(key).strftime('%Y-%-m'), value] 
					}
				assigned_issues = categories.map do |x| 
					selected = assigned_issues.select{ |y| y.first == x }.first	
					selected.nil? ? [x, 0] :  [x, selected[1] ]
				end
				closed_issues = IssueTracker.where(
					:user_id => user.id , :new_status_id => IssueStatus.find_by_name('Closed').id).group_by_month.map{ 
						|key,value| [Date.parse(key).strftime('%Y-%-m'), value] 
					}
				closed_issues = categories.map do |x| 
					selected = closed_issues.select{ |y| y.first == x }.first	
					selected.nil? ? [x, 0] :  [x, selected[1] ]
				end
			
				extra_info = IssueExtraInfo.where(:issue_id => Issue.where(:user_id => user.id).pluck(:id) ).group_by_month.map{
						|key,value| [ Date.parse(key).strftime('%Y-%-m'), value ]
					}
				extra_info = categories.map do |x| 
					selected = extra_info.select{ |y| y.first == x }.first	
					selected.nil? ? [x, 0] :  [x, selected[1] ]
				end

				#gather IssueExtraInfo performance data
				render :json => { 
					:chart1 =>  { 
						:categories => categories,
						:series => [ 
							{ :name => 'Opened', :data => opened_issues },
							{ :name => 'Assigned', :data => assigned_issues },
							{ :name => 'Closed', :data => closed_issues }
						]
					},
					:chart2 => {
						:categories => categories,
						:series => [
							{ :name => 'Count', :data => extra_info }
						]
					}
				 }
			}
		end #respond_to
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
