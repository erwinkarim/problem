class AppMailer < ApplicationMailer

	default from: ENV["email_address"]

	def test(user)
		@user = user
		mail(:to => user.email, :subject => "#{ENV["site_brand"]}: Test") 
	end

	def new_issue(issue)
		@user = User.find_by_id(issue.user_id)
		@issue = issue

		mail(
			:to => @user.email,
			:subject => "#{ENV["site_brand"]}: Issue #{ @issue.id } created"
		)
	end

	def status_update(issue)
		@user = User.find_by_id(issue.user_id)
		@issue = issue
		@latest_tracker = issue.issue_trackers.last
		
		mail(
			:to => @user.email, 
			:subject => "#{ENV["site_brand"]}: Status for Issue #{ @issue.id } updated to #{@latest_tracker.new_status.name}"
		)
	end
end
