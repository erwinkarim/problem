class IssuesController < ApplicationController
	def index
		if !current_user.admin? then
			redirect_to user_issues_path(current_user)
		end

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
		#sanity check
		if params[:issue][:description].empty? then
			flash[:error] = "Description Can't be Blank"
			redirect_to :back
		end

		if params[:affected_user_mails].nil? then
			params[:affected_user_mails] = [current_user.email]
		end

		#check for user affected_user parameter
		#user = User.find_by_id(params[:user_id])
		issues = Array.new

		#build the issues one by one and send out notification email at each one
		params[:affected_user_mails].uniq.each do |user_mail|
			#find the user
			affected_user = User.find_by_email(user_mail)
			if affected_user.nil? then
				affected_user = User.find_by_mail(user_mail, "#{current_user.username}@#{current_user.domain}", session[:password])
			end

			#since the users are selected from ad in the first place, affected_user must be real
			#create the issue
			issue = affected_user.issues.new(
				:description => params[:issue][:description], :affected_user_id => affected_user.id,
				:user_id => current_user.id
			)
			if issue.valid? then
				issue.save!
				issue.issue_trackers.new({:new_status_id => IssueStatus.find_by_name('Open').id,
					:user_id => params[:user_id], :comment => 'Issue Created by Reporter'}).save!
				issues << issue

				#generate new status

				#handle extra_info
				if params.has_key? :extra_info then
					params[:extra_info].each do |extra_info|
						issue.issue_extra_infos.new(
							:extra_info_detail_id => extra_info[1]["detail_id"],
							:string_val => extra_info[1]["input"] ).save!
					end
				end

				#send out email
				AppMailer.new_issue(issue).deliver_later
			end
		end

		#flash and redirect
		@issue = issues.first
		flash[:notice] = "Issues #{issues.map{|x| view_context.link_to(x.id, issue_path(x.id), :target => '_blank')}.join(',')} created"
		redirect_to user_issue_path(params[:user_id], issues.first.id)
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

		#don't cater for changing affected user

		if @issue.update_attributes(issue_params) then
			#purne extra_info list (drop extra_info that is not in the list)
			#find extra_info ids that is not in the new list and delete them
			if params.has_key? :extra_info then
				@issue.issue_extra_infos.where.not(:id => params[:extra_info].collect{ |x| x[0] } ).destroy_all
			else
				#absolutely on extra info. so destroy everything on site
				@issue.issue_extra_infos.destroy_all
			end

			#handle existing/new extra_info
			if params.has_key? :extra_info then
				params[:extra_info].each do |extra_info|
					issue_extra_info = IssueExtraInfo.find_by_id extra_info[0]
					if issue_extra_info.nil? then
						issue_extra_info = @issue.issue_extra_infos.new(
							:extra_info_detail_id => extra_info[1][:detail_id], :string_val => extra_info[1][:input]
						)
					else
						issue_extra_info.assign_attributes(
							:extra_info_detail_id => extra_info[1][:detail_id], :string_val => extra_info[1][:input]
						)
					end
					issue_extra_info.save!
				end
			end

			@issue.issue_trackers.new(
				:new_status_id => IssueStatus.find_by_name('Description Modified').id,
				:user_id => current_user.id,
				:comment => 'Reporter Update Issue Description'
			).save!
			flash[:sucess] = "Issue #{@issue.id} updated"
			redirect_to user_issue_path(@user,@issue)
		else
			flash[:alert] = 'Error is updating issue: ' + @issue.errors.full_messages.join(';')
			redirect_to edit_user_issue_path(@user, @issue)
		end
	end

	#  POST   /issues/search(.:format)                       issues#search
	def search
		users_id = []
		issues_id = []

		params[:query].split(" ").each do | pattern |
			#get users w/ the pattern
			users_id.push( User.where('name like ?', "%#{pattern}%").pluck(:id) )

			#get issues have the description matches the query
			issues_id.push( Issue.where('description like ?', "%#{pattern}%").pluck(:id) )
		end

		#get issues reported by the person
		issues_id.push( Issue.where(:user_id => users_id.flatten.uniq).pluck(:id) )

		#get issues assigned to the person
		issues_id.push( Issue.where(:assignee_id => users_id.flatten.uniq).pluck(:id) )

		#of course, when the query is actually a issue id, plug that in too
		issues_id.push(params[:query].split(" ") )

		#now return the issues from a list of issue ids
		@issues = Issue.where(:id => issues_id.flatten.uniq).order(:created_at => :desc)

		respond_to do |format|
			format.html
		end

	end

	#  GET    /users/:user_id/issues
	def user_issues
		@user = User.find_by_id(params[:user_id]) or not_found
		t = Issue.arel_table
		@issues = Issue.where(
			(t[:user_id].eq(@user.id)).or(t[:affected_user_id].eq(@user.id))
		)
		#@issues = @user.issues.order(:created_at => :desc)

		respond_to do |format|
			format.html
		end
	end


	private

	def issue_params
		params.require(:issue).permit(:description, :affected_user_id, :created_at)
	end
end
