require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

#auto close resolved issue
scheduler.every '15m' do
	AutoCloseIssueJob.perform_now
end
