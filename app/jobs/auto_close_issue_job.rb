class AutoCloseIssueJob < ActiveJob::Base
	RUN_EVERY = 30.second

  queue_as :default

  def perform(*args)
    # Do something later
		# Look for resolved cases and auto close them if the case has been resolved for over a week
		Rails.logger.info DateTime.now.to_s + ": AutoCloseIssue Job run"

		issues = Issue.where(:id => 
			IssueTracker.group(:issue_id).having( 
				'max(created_at) and new_status_id = ? and created_at < ?', IssueStatus.find_by_name('Resolved').id, 1.week.ago
			).pluck(:issue_id)
		)

		issues.each do |issue|
			issue.issue_trackers.new(
				:new_status_id => IssueStatus.find_by_name('Closed').id,
				:comment => "Issue Auto Close by #{ENV["site_brand"]}",
				:user_id => issue.user_id
			).save!

			AppMailer.status_update(issue).deliver_later
		end
  end
end
