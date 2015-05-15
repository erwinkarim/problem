class AppMailer < ApplicationMailer

	default from: ENV['email_reply_address']

	def test(user)
		@user = user
		mail(:to => user.email, :subject => "#{Setting.getValue('site', 'brand') }: Test") 
	end

	def new_issue(issue)
		@user = User.find_by_id(issue.user_id)
		@issue = issue

		mail(
			:to => @user.email,
			:subject => "#{Setting.getValue('site', 'brand') }: Issue #{ @issue.id } created"
		)
	end

	def status_update(issue)
		@user = User.find_by_id(issue.user_id)
		@issue = issue
		@latest_tracker = issue.issue_trackers.last
		
		mail(
			:to => @user.email, 
			:subject => "#{Setting.getValue('site', 'brand') }: Status for Issue #{ @issue.id } updated to #{@latest_tracker.new_status.name}"
		)
	end
end
