class IssueTrackersController < ApplicationController
	# GET    /issues/:issue_id/issue_trackers/new
	def new
		@issue = Issue.find_by_id(params[:issue_id]) or not_found
		@issue_tracker = @issue.issue_trackers.new
	end

	# /issues/:issue_id/issue_trackers/new(
	#  POST   /issues/:issue_id/issue_trackers
	def create
		issue = Issue.find_by_id(params[:issue_id])
		@issue_tracker = issue.issue_trackers.new(params_issue_tracker)

		if @issue_tracker.valid? && @issue_tracker.save! then
			#handle cases where the tracker has been create
			if( @issue_tracker.new_status.name == 'Assigned') then
				issue.update_attribute :assignee_id, current_user.id
			end
			redirect_to issue_path(params[:issue_id])
		else
			flash[:alert] = 'Error in saving'
			redirect_to new_issue_issue_tracker_path(params[:issue_id], :issue_tracker => @issue_tracker)
		end
	end

	private
	def params_issue_tracker
		params.require(:issue_tracker).permit(:new_status_id, :comment, :user_id )
	end
end
