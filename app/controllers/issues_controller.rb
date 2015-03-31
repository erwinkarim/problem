class IssuesController < ApplicationController
	def index
		#get open issues
		@issues = Issue.where( :id => 
			IssueTracker.group(:issue_id).having(
				'max(created_at) and new_status_id not in (?)', 
				IssueStatus.where(:name => ['Resolved', 'Closed']).pluck(:id)
			).pluck(:issue_id)
		).order(:created_at => :desc)
	end
	
	#  GET    /users/:user_id/issues/new
	def new
		@user = User.find_by_id(params[:user_id])
		@issue = @user.issues.new
		@target_url = user_issues_path(@user)
	end

	#  POST   /users/:user_id/issues(.:format)
	def create
		@issue = User.find_by_id(params[:user_id]).issues.new(issue_params)

		if @issue.save! then
			@issue.issue_trackers.new({:new_status_id => IssueStatus.find_by_name('Open').id, 
				:user_id => params[:user_id], :comment => 'Issue Created by Reporter'}).save!

			#handle extra_info
			params[:extra_info].each do |extra_info|
				@issue.issue_extra_infos.new(
					:extra_info_detail_id => extra_info[1]["detail_id"], 
					:string_val => extra_info[1]["input"] ).save!
			end

			redirect_to user_issue_path(params[:user_id], @issue)

		else
			flash[:alert] = 'Error in saving'
			redirect_to new_user_issue(params[:user_id])
		end
	end

	# GET    /issues/:id(.:format)
	# GET    /users/:user_id/issues/:id
	def show
		@issue = Issue.find_by_id(params[:id]) or not_found
		@user = User.find_by_id(@issue.user_id) or not_found
		@issue_trackers = @issue.issue_trackers.order(:created_at)

		respond_to do |format|
			format.html
		end
	end

	# GET    /users/:user_id/issues/:id/edit
	def edit
		@user = User.find_by_id(params[:user_id]) or not_found
		@issue = @user.issues.find_by_id(params[:id]) or not_found
		@target_url = user_issue_path(@user, @issue)
	end


	def update
		@user = User.find_by_id(params[:user_id]) or not_found
		@issue = @user.issues.find_by_id(params[:id]) or not_found

		if @issue.update_attributes(issue_params) then
			@issue.issue_trackers.new(
				:new_status_id => IssueStatus.find_by_name('Description Modified').id, 
				:user_id => current_user.id,
				:comment => 'Reporter Update Issue Description'
			).save!
			redirect_to user_issue_path(@user,@issue)
		else
			flash[:alert] = 'Error is updating issue'
			redirect_to edit_user_issue_path(@user, @issue)
		end
	end

	#  POST   /issues/search(.:format)                       issues#search
	def search
		@issue = Issue.find_by_id(params[:id]) or not_found

		respond_to do |format|
			format.html{ redirect_to issue_path(@issue) }
		end

	end
	
	#  GET    /users/:user_id/issues
	def user_issues
		@user = User.find_by_id(params[:user_id]) or not_found
		@issues = @user.issues.order(:created_at => :desc)

		respond_to do |format|
			format.html
		end
	end

	private
	
	def issue_params
		params.require(:issue).permit(:description)
	end
end
