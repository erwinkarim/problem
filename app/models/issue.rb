class Issue < ActiveRecord::Base
  belongs_to :user
	belongs_to :assignee, :class_name => 'User'
	validates_presence_of :description

	has_many :issue_trackers

	#returns possible status w/ the current issue
	def next_issue_status_options

		#get current status w/o comments and description edits
		current_status = self.issue_trackers.where.not(
			:new_status_id => IssueStatus.where(:name => ['Description Modified', 'Additional Comments'] ).pluck(:id) 
		).order(:created_at => :desc).first.new_status.name

		if (current_status == 'Open') then
			return IssueStatus.where(:name => ['Acknowledged'])
		elsif (current_status == 'Acknowledged') then
			return IssueStatus.where(:name => ['Assigned'])
		elsif (current_status == 'Assigned') then
			return IssueStatus.where(:name => ['User Uncontactable', 'Escalate To Vendor', 'Resolved'])
		elsif (current_status =='User Uncontactable') then
			return IssueStatus.where(:name => ['User Uncontactable', 'Escalate To Vendor', 'Resolved'])
		elsif (current_status =='Escalate To Vendor') then
			return IssueStatus.where(:name => ['User Uncontactable', 'Escalate To Vendor', 'Resolved'])
		elsif (current_status =='Resolved') then
			return IssueStatus.where(:name => ['Closed', 'Reopen'])
		elsif (current_status =='Reopen') then
			return IssueStatus.where(:name => ['Assigned'])
		else
			return nil
		end
	end

	# same thing as next_issue_status_options, but returns in form of [name, id] array for html select tag
	def next_issue_status_options_for_select

		options = self.next_issue_status_options
		if options.nil? then
			return nil
		else
			return options.collect{ |x| [x.name, x.id] }
		end
	end


end
