class AppMailer < ApplicationMailer

	default from: ENV['email_reply_address']

	def test(user)
		@user = user
		mail(:to => user.email, :subject => "#{Setting.getValue('site', 'brand') }: Test") 
	end

	def new_issue(issue)
		@user = User.find_by_id(issue.user_id)
		@issue = issue

		mailing_list = [ issue.user.email ]
		if !issue.affected_user.nil? && (issue.affected_user_id != issue.user_id) then
			mailing_list << issue.affected_user.email
		end

		mail(
			:to => mailing_list,
			:subject => "#{Setting.getValue('site', 'brand') }: Issue #{ @issue.id } created"
		)
	end

	def status_update(issue)
		@user = User.find_by_id(issue.user_id)
		@issue = issue
		@latest_tracker = issue.issue_trackers.last
		
		mailing_list = [ issue.user.email ]
		if !issue.affected_user.nil? && (issue.affected_user_id != issue.user_id) then
			mailing_list << issue.affected_user.email
		end

		mail(
			:to => mailing_list,
			:subject => "#{Setting.getValue('site', 'brand') }: Status for Issue #{ @issue.id } updated to #{@latest_tracker.new_status.name}"
		)
	end
end
